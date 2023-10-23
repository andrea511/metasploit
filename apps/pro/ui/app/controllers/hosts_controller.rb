class HostsController < ApplicationController
  include AnalysisSearchMethods
  include ApplicationHelper
  include HostsHelper
  include TableResponder

  has_scope :workspace_id, only: [:index, :destroy_multiple, :quick_multi_tag]

  HOST_TAB_ACTIONS  = [ :services, :sessions, :vulns, :web_vulns, :shares, :loots, :notes, :creds, :tags,
                        :attempts, :details, :exploits ]

  DATATABLE_ACTIONS = [ :show_services, :update_service, :delete_service, :show_captured_data,
                        :show_alive_sessions, :show_dead_sessions, :update_cred, :delete_cred,
                        :show_history, :show_notes, :create_service, :create_cred ]
  STATUS_SORT_COL   = '11'

  # These verify that the workspace is accessible by the current user:
  before_action :load_workspace, :except => [:show, :edit, :update, :poll_presenter, :tags] + HOST_TAB_ACTIONS + DATATABLE_ACTIONS
  before_action :verify_workspace, :only => [:show, :edit, :update, :poll_presenter, :tags] + HOST_TAB_ACTIONS + DATATABLE_ACTIONS

  before_action :load_host, :only => [:show, :poll_presenter] + HOST_TAB_ACTIONS + DATATABLE_ACTIONS

  require 'shellwords'

  def index
    @stats = @workspace.stats

    sort_by = params[:sort_by] || 'address'
    sort_dir = params[:sort_dir] || 'asc'

    # todo: kick this out to a presenter
    if request.format.json? and params[:dataTable]
      @hosts = pro_search(:hosts,false)
      @hosts_total_display_count = @hosts.length

      if params[:iDisplayLength] == '-1'
        @hosts_per_page = nil
      else
        @hosts_per_page = (params[:iDisplayLength] || 20).to_i
      end

      @hosts_offset = (params[:iDisplayStart] || 0).to_i

      if params[:iSortCol_0] == STATUS_SORT_COL
        # When sorting by status, the status is determined by Ruby code in
        #   Mdm::Host#status => lib/mdm/host/decorator.rb:10
        # So unfortunately we have to load all hosts into memory, then
        #   sort them in Ruby by comparing the calculated statuses.
        # We can do this quickly since we keep the counts for these
        #   calculations cached in @workspace.status, but a SQL solution
        #   would be preferred.
        @hosts = sort_hosts_by_status(@hosts)

        unless @hosts_per_page.nil? # paginate unless Show -> All
          @hosts = @hosts[@hosts_offset...@hosts_offset+@hosts_per_page]
        end
      else
        # Otherwise just add a limit to the ActiveRecord::Relation
        @hosts = @hosts
          .offset(@hosts_offset)
          .order(hosts_sort_option)
          .limit(@hosts_per_page)
      end
      @hosts_total_display_count ||= @hosts_total_count
    end

    respond_to do |format|
      format.html
      format.json {
        if params[:dataTable]
          render :partial => 'hosts', :hosts => @hosts
        else
          respond_with_table(
              Mdm::Host,
              presenter_class: Mdm::HostIndexPresenter,
              includes: [:tags],
              selections: ( params[:selections] || {} ).merge(ignore_if_no_selections: true)
          )
        end
      }
    end
  end

  #
  # Endpoint for Backbone Entities.HostsCollection, "hosts:entities:limited"
  #
  def hosts_json_limited
    @hosts = Mdm::Host.select([:id,:name,:address]).where(workspace_id:@workspace)
    render json: @hosts
  end

  def edit
    @host = Mdm::Host.find(params[:id])
  end

  def new
    @host = @workspace.hosts.build
  end

  def create
    @host = Mdm::Host.new(hosts_params)
    @host.state = 'alive'
    if @host.save
      flash[:notice] = "Host created"
      redirect_to @host
    else
      render :action => 'new'
    end
  end

  def map
    if not License.get.supports_map?
      redirect_to hosts_path(@workspace)
      return
    end

    tag_search = false
    if params[:search].blank?
      @hosts = @workspace.hosts.includes(:notes)
    else
      @search = params[:search].to_s
      search_terms = ::Shellwords.shellwords(@search) rescue @search.split(/\s+/)

      @hosts = @workspace.hosts.alive

      search_terms.each do |term|
        if term =~ /^#(.*)/
          @hosts = @hosts.tag_search($1)
          tag_search = true
        else
          @hosts = @hosts.search(term)
        end
      end
    end

    @total_nodes = 0

    @traceroutes = {"ip" => "localhost", "os_name"=>"localhost", "name"=>"Metasploit Pro", "depth"=>0,"children" => []}

    traceroute = false
    @hosts.each do |host|
      host.notes.each do |note|
        if note.ntype == "host.nmap.traceroute"
          add_to_routes(note.data["hops"])
          @total_nodes = @total_nodes + note.data["hops"].length
          traceroute = true
        end
      end
      if (not traceroute and !params[:trace_hosts]) or tag_search
        @traceroutes["children"].push({"ip"=>host.address,"no_traceroute"=>true,"depth"=>1,"children"=>[]})
        @total_nodes = @total_nodes + 1
      end

      traceroute = false
      add_route_data(host,@traceroutes)
    end

    if @total_nodes > 500
      flash[:nodes] = "The total number of nodes is greater than 500 which can cause the page to slow down. "
      flash[:nodes] << "Click CONTINUE below to load the map with all nodes or use the search functionality"
      flash[:nodes] << " (e.g. 10.0.0., printers, #imported) to lower the number of nodes rendered."
      flash[:nodes] << "  Current Total Nodes: #{@total_nodes}."
    else
      flash[:nodes] = nil
    end
    respond_to do |format|
      format.html
      format.json { render :partial => 'maps', formats => [:json], :maps => @traceroutes, :total_nodes=>@total_nodes }
    end
  end


  # Mdm::Note that host tags should be uniq by name and inclusion in this
  # workspace, which is why this doesn't call Mdm::Tag.new directly, but
  # first looks for a tag associated with a host in this workspace,
  # and if that fails, Mdm::Tag.new. This would be easier with a workspace_id
  # on the Mdm::Tag itself. The upside is that it removes a constraint (the
  # workspace_id), and might make tag searching cross-workspace a little
  # easier -- right now tag searching is intentionally restrained to
  # be limited to a workspace.
  def _create_or_update_tag(args={})
    host_id = args[:host_id]
    @host = Mdm::Host.find(host_id)
    unless @host
      flash[:error] = "Host #{host_id} not found."
    end
    workspace_id = @host.workspace_id
    possible_tag = Mdm::Tag.where("hosts.workspace_id = ? and tags.name = ?", workspace_id, args[:name]).includes(:hosts).first
    @tag = possible_tag || Mdm::Tag.new
    @tag.name = args[:name]
    @tag.user_id = args[:user_id]
    @tag.report_summary = args[:report_summary] if !args[:report_summary].nil?
    @tag.report_detail = args[:report_detail] if !args[:report_detail].nil?
    @tag.critical = args[:critical] if !args[:critical].nil?
    if !args[:desc].nil? && !args[:desc].strip.empty?
      @tag.desc = args[:desc]
    end
    @tag.add_host_by_id(host_id)
    @tag.save
    return @tag
  end

  def create_or_update_tag
    case params[:commit]
    when /^(Save|Update)/
      args = {
        :host_id => params[:id],
        :name => params[:tag][:name],
        :desc => params[:tag][:desc],
        :user_id => @current_user.id
      }
      args[:report_summary] = !!(params[:tag][:report_summary] == "1")
      args[:report_detail] =  !!(params[:tag][:report_detail]  == "1")
      args[:critical] =       !!(params[:tag][:critical]       == "1")
      tag = _create_or_update_tag(args)
      unless tag.errors.empty?
        flash[:error] = "%s %s" % [tag.errors.first[0], tag.errors.first[1]]
      else
        flash[:notice] = "Tag ##{h tag.name} %s." % [tag.updated? ? 'updated' : 'created']
      end
    when /^(Remove|Delete)/
      this_tag = Mdm::Tag.find(params[:tag_id])
      this_tag.hosts.delete (host = Mdm::Host.find(params[:id]))
      flash[:notice] = "Removed ##{this_tag.name} from #{host.name || host.to_s}"
      unless this_tag.save
        flash[:error] = @tag.errors
      end
    end
    redirect_to host_path(params[:id]) + "#tags"
  end

  # Handles creating/associating Tag records with Hosts in the same workspace
  # params:
  #   :host_ids => an array of ids of hosts to tag
  #   :new_host_tags => a comma-separate list of tags
  #   :preserve_existing => true to keep existing tags on a single host. defaults to false.
  #   :workspace_id => id of the workspace
  def quick_multi_tag
    if params[:host_ids]
      #todo: make this a .where
      tags_invalid = false
      saved_tags = {} # save a tag after you add it, and reuse on next host


      hosts = params[:host_ids].collect { |id| Mdm::Host.find(id.to_i) }

      if params[:new_host_tags] && params[:host_ids]
        if params[:host_ids].size == 1
          # if only one host specified, make host.tags an *exact* replica of new_host_tags,
          # so clear host.tags before appending
          unless params[:preserve_existing]
            hosts.first.tags.clear
          end
        end
      end

      hosts.each do |host|
        names = params[:new_host_tags].split(',').uniq
        names.each { |name|
          if saved_tags[name].present?
            host.add_tag saved_tags[name]
          else
            saved_tags[name] = host.add_tag_by_name name
          end
          # Note: check for manual errors first since valid? clears all errors
          tags_invalid = (saved_tags[name].errors.any? || !saved_tags[name].valid?)
        }
      end

      error_msg = if tags_invalid
        # convert name=>tag hash to array of tags
        tags = saved_tags.flatten.select { |t| t.class <= Mdm::Tag }
        # generate an error message for it
        tags.select { |t| t.errors.any? }.first.errors.full_messages.join ', '
      end

      respond_to do |format|
        format.html { redirect_back }
        format.js do
          if tags_invalid
            render :plain => error_msg, :status => 403
          else
            render :body => nil, :status => 200
          end
        end
        format.json do
          if tags_invalid
            render :json => {success:false, error: error_msg}, :status => 403
          else
            # returns the rendered JSON poll presenter on success
            @host = hosts.first
            @exploits = build_exploit_match
            poll_presenter
          end
        end
      end
    elsif params[:selections]
      selected_hosts = load_filtered_records(Mdm::Host, params)
      params['entity_ids'] = selected_hosts.collect(&:id)

      render json: TagCreator.build(
                 params, Mdm::Host, relation: selected_hosts)
    end
  end

  def multi_tag
    if params[:host_ids]
      args = {
        :user_id => @current_user.id,
        :name => params[:name],
        :desc => params[:desc],
      }
      if params[:tag_attributes]
        args[:report_summary] = params[:tag_attributes].include? "report_summary"
        args[:report_detail] =  params[:tag_attributes].include? "report_detail"
        args[:critical] =       params[:tag_attributes].include? "critical"
      end
      successful_hosts = []
      params[:host_ids].each do |host_id|
        tag = _create_or_update_tag(args.merge(:host_id => host_id.to_i))
        unless tag.errors.empty?
          flash[:error] = tag.errors
          break
        end
        successful_hosts << Mdm::Host.find(host_id).address
      end
      if successful_hosts.size == params[:host_ids].size
        flash[:notice] = "Applied tag ##{h args[:name]} to #{ActionController::Base.helpers.pluralize(successful_hosts.size, 'host')}"
      end
    else
      flash[:error] ||= "No hosts were selected to tag."
    end
    render_js_redirect(hosts_path(@workspace))
  end

  def remove_tag
    host_id = params[:remove_tag][:host_id]
    begin
      @host = Mdm::Host.find(host_id)
    rescue
      respond_to do |format|
        format.any(:js, :html) do
          redirect_to hosts_path(params[:workspace_id])
        end
        format.json do
          render :json => {:success => false, :error => "Host not found."}, :status => :bad_request
        end
      end
    end
    if params[:tag_ids].nil? || params[:tag_ids].empty?
      @error =  "No tags were selected to remove."
    else
      params[:tag_ids].each do |tid|
        @tag = Mdm::Tag.find_by_id(tid)
        @tag.hosts.delete @host
        @tag.destroy if @tag.hosts.empty?
      end
    end
    respond_to do |format|
      format.any(:js, :html) do
        flash[:error] = @error if @error.present?
        redirect_to host_path(@host) + "#tags"
      end
      format.json do
        if @error.blank?
          render :json => {:success => :ok}
        else
          render :json => {:success => false, :error => @error}, :status => :bad_request
        end
      end
    end
  end

  def update
    @host = Mdm::Host.find(params[:id])
    orig = @host.attributes.dup
    orig_services = @host.services.clone
    notice_msg = ''

    if @host.update(hosts_params)
      diff = @host.attributes.reject {|k,v| (k == "updated_at") || (orig[k] == v) }
      services_match = (orig_services == @host.services && orig_services.size == @host.services.count)
      if !diff.empty? || !services_match
        diff.each_pair do |k,v|
          note = @host.notes.where(ntype: "host.updated.#{k}", host_id: @host.id).first_or_initialize
          note.workspace_id = @workspace.id
          note.data = {:user => current_user.username,
            :value => v,
            :locked => (params[:host][:lock_attrs] == "1" ? true : false)
          }
          note.save!
        end
        notice_msg = "Host updated"
      else
        notice_msg = "No updates"
      end

      respond_to do |format|
        format.html do
          flash[:notice] = notice_msg
          redirect_to @host
        end
        format.json do
          @exploits = build_exploit_match
          poll_presenter
        end
      end
    else
      respond_to do |format|
        format.html do
          render :action => 'edit'
        end
        format.json do
          render :json => { :success => false, :errors => @host.errors.messages }, :status => :bad_request
        end
      end
    end
  end

  def show
    # TODO: These should probably be block helpers. Doesn't need
    # to be in the controller.
    @has_services = ( @host.services.size > 0 )
    @has_sessions = ( @host.sessions.size > 0 )
    @has_shares   = ( (@host.smb_shares.size + @host.nfs_exports.size) > 0 )
    @has_loot     = ( @host.loots.size > 0 )
    @has_notes    = ( @host.notes.size > 0 )
    @has_creds    = ( @host.creds.size > 0 )

    respond_to do |format|
      format.html
      format.xml { render :xml => @host }
    end
    @host.clear_flags
  end

#
# TODO: ONLY 1 or 2 of the following tab routes should be saved, kill the rest, including partials!
#
  def services
    respond_to do |format|
      format.js { render :partial => "services_tab", :content_type => "text/html" }
    end
  end

  def sessions
    respond_to do |format|
      format.js { render :partial => "sessions",  :content_type => "text/html" }
    end
  end

  def vulns
    respond_to do |format|
      format.js { render :partial => "vulns_tab",  :content_type => "text/html"}
    end
  end

  def web_vulns
    respond_to do |format|
      format.js { render :partial => "web_vulns_tab",  :content_type => "text/html"}
    end
  end

  def shares
    respond_to do |format|
      format.js { render :partial => "shares_tab",  :content_type => "text/html"}
    end
  end

  def loots
    respond_to do |format|
      format.js { render :partial => "loots", :locals => { :loots => @host.loots },  :content_type => "text/html"}
    end
  end

  def notes
    respond_to do |format|
      format.js { render :partial => "notes", :locals => { :notes => @host.notes },  :content_type => "text/html"}
    end
  end

  def creds
    @services = @host.services.select("id,name,port,proto")
    respond_to do |format|
      format.js do
        render :partial => "generic/auths",
          :locals => {:show_timestamps => true, :detailed => true, :password_mask_bool => false, :host_record => true},
          :object => @workspace.creds.select {|cred| cred.service.host == @host},
          :content_type => "text/html"
      end
    end
  end

  def tags
    respond_to do |format|
      format.js { render :partial => "tags",  :content_type => "text/html" }
      format.json{
        #Because the load_host before filter loads more host attributes than we need.
        host = Mdm::Host.select(:id).includes(:tags).where(workspace_id:@workspace, id:params[:id]).last
        render json: host.as_json(include: :tags), status: :ok
      }
    end
  end

  def attempts
    @exploit_attempts = @host.exploit_attempts.
      select("exploit_attempts.*, module_details.name AS module_name").
      from("exploit_attempts,module_details").
      where("exploit_attempts.module = module_details.fullname")
    respond_to do |format|
      format.js { render :partial => "exploit_attempts_tab", :locals => { :host => @host }, :content_type => "text/html"}
    end
  end

  def details
    respond_to do |format|
      format.js { render :partial => "host_details_tab", :locals => { :host => @host }, :content_type => "text/html"}
    end
  end

  def exploits
    respond_to do |format|
      format.js { render :partial => "host_exploits_tab", :locals => { :host => @host },  :content_type => "text/html"}
      format.json { render :json => @exploits }
    end
  end

  def destroy
    host_ids = [params[:id]]       if params[:id]
    host_ids = params[:host_ids]   if params[:host_ids]

    hosts = Mdm::Host.destroy(host_ids)

    if hosts.length.zero?
      flash[:error] = "No hosts selected to delete"
    else
      flash[:notice] = view_context.pluralize(hosts.length, "host") + " deleted"
    end

    render_js_redirect(hosts_path(@workspace))
  end

  def destroy_multiple
    begin
      load_filtered_records(Mdm::Host, params).readonly(false).destroy_all

      render json: { success: true }
    rescue
      render json: { success: false }
    end
  end

  #
  # Datatable endpoints for the new Host#show hotness
  # These could probably be moved to a concern/mixin.
  #
  def show_alive_sessions
    respond_to do |format|
      format.json do
        render :json => DataTableQueryResponse.build(params, {
          :collection => @host.sessions.alive,
          :columns => [:id, :history ,:stype, :opened_at, :via_exploit]
        })
      end
    end
  end

  def show_dead_sessions
    respond_to do |format|
      format.json do
        render :json => DataTableQueryResponse.build(params, {
          :collection => @host.sessions.dead,
          :columns => [:id, :history, :stype, :opened_at, :via_exploit]
        })
      end
    end
  end

  def show_creds
    respond_to do |format|
      format.json do
        finder = CredsFinder.new(@host)
        render :json => DataTableQueryResponse.new(finder, params)
      end
    end
  end

  def show_captured_data
    respond_to do |format|
      format.json do
        render :json => DataTableQueryResponse.build(params, {
          :collection => @host.loots,
          :columns => [:name, :ltype, :content_type, :info, :size, :created_at, :actions, :edit, :id],
          :search_cols => [:name, :ltype],
          :render_row => lambda do |loot|
            { :size => loot.size,
              :path => loot_path(loot),
              :is_img => !!loot.image?,
              :is_text => !!loot.text?,
              :is_binary => !!loot.binary? }
          end
        })
      end
    end
  end

  def show_services

    respond_to do |format|
      format.json do
        render_services
      end

      format.js do
        render_services
      end
    end

  end

  def show_history
    respond_to do |format|
      format.json do
        render :json => DataTableQueryResponse.build(params, {
          :collection => Mdm::Event.where(:host_id => @host.id),
          :columns => [:name, :username, :info, :created_at]
        })
      end
    end
  end

  def show_notes
    respond_to do |format|
      format.json do
        render :json => DataTableQueryResponse.build(params, {
          :collection => @host.notes,
          :columns => [:ntype, :data, :updated_at]
        })
      end
    end
  end

  def update_cred
    respond_to do |format|
      format.json {
        cred = Mdm::Cred.find(params[:aaData][:id])
        params[:aaData][:service] = Mdm::Service.find_by_id(params[:aaData][:service])
        params[:aaData][:ptype] = Mdm::Cred::PTYPES[params[:aaData][:ptype]]
        cred.update(params[:aaData])
        render :json => {success: "ok"}
      }
    end
  end

  def create_cred
    respond_to do |format|
      format.json {
        params[:aaData][:service] = Mdm::Service.find_by_id(params[:aaData][:service])
        params[:aaData][:ptype] = Mdm::Cred::PTYPES[params[:aaData][:ptype]]
        result = Mdm::Cred.new(params[:aaData])

        if result.save
          render :json => {success:"ok"}
        else
          render :json => {success: false, :error => result.errors.messages }, :status => :bad_request
        end
      }
    end
  end

  def create_service
    service  = @host.services.new(aadata_params)

    respond_to do |format|
      format.json {
        if service.save(context: :single_host_view)
          render :json => {success: "ok"}
        else
          render json: {sucesss:false, error: service.errors.messages}, status: :bad_request
        end
      }
    end

  end


  def update_service
    aaData = aadata_params
    respond_to do |format|
      format.json {
        unless aaData.nil?
          @service = @host.services.find(aaData[:id])
          @service.assign_attributes(aaData)
          if @service.save(context: :single_host_view)
            render json: {success: "ok"}
          else
            render json: {success: false, error: @service.errors.messages}, status: :bad_request
          end
        else
            render json: {success: false}, status: :error
        end
      }
    end

  end

  def poll_presenter
    presenter = Hosts::SingleHostPresenter.new({
      :host => @host,
      :controller => self,
      :exploits => @exploits
    })
    respond_to do |format|
      format.json { render :json => presenter.as_json }
    end
  end


  def delete_service
    begin
      @service = Mdm::Host.find(params[:id]).services.find(params[:aaData][:id])
      @service.destroy
      render :json => {success: "ok"}
    rescue ActiveRecord::RecordNotFound => e
      render :json => {success: false, :error => "Record not found"}, :status => :bad_request
    end
  end


  def delete_cred
    begin
      @cred = Mdm::Cred.find(params[:aaData][:id])
      @cred.destroy
      render :json => {success: "ok"}
    rescue ActiveRecord::RecordNotFound => e
      render :json => {success: false, :error => "Record not found"}, :status => :bad_request
    end
  end

  private

  def verify_workspace
    @workspace = Mdm::Host.find(params[:id]).workspace
    unless @workspace.usable_by?(current_user)
      respond_to do |format|
        error_msg = "You are not a member of this project"
        format.html { render :plain => error_msg, :layout => "forbidden", :status => 403 }
        format.json { render :json => {error: error_msg} , :status => 403 }
      end
    end
  end

  def render_services
    if params[:dataTable]
      render :json => DataTableQueryResponse.build(params, {
          :collection => @host.services,
          :columns => [:name, :port, :proto, :state, :info, :created_at, :edit, :id],
          :search_cols => [:name, :proto, :state, :info]
      })
    else
      render :json => @host.services
    end
  end

  # Generate a SQL sort by option based on the incoming DataTables paramater.
  #
  # Returns the SQL String.
  def hosts_sort_option
    column = case params[:iSortCol_0]
             when '1'
               'inet(hosts.address)'
             when '2'
               'hosts.name'
             when '3'
               'hosts.os_name'
             when '4'
               'hosts.virtual_host'
             when '5'
               'hosts.purpose'
             when '6'
               'service_count'
             when '7'
               'vuln_count'
             when '8'
               'exploit_attempt_count'
             when '9'
               'tag_count'
             when '10'
               'hosts.updated_at'
             when '11'

             end
    column + ' ' + (params[:sSortDir_0] =~ /^A/i ? 'asc' : 'desc') if column
  end

  # @return [Array<Mdm::Host>] sorted by the user's column options
  def sort_hosts_by_status(hosts)
    desc = params[:sSortDir_0] == 'desc'
    @stats ||= @workspace.stats
    if desc
      hosts.to_a.sort! do |a,b|
        [b.status(@stats), a.address] <=> [a.status(@stats), b.address]
      end
    else
      hosts.to_a.sort! do |a,b|
        [a.status(@stats), a.address] <=> [b.status(@stats), b.address]
      end
    end
  end

  def create_tuples(hops)
    tuples = []
    for pos in (0..hops.length) do
      next if not hops[pos]
      if hops[pos]["ttl"] == "1"
        tuples.push([{"ip"=>"127.0.0.1"},{"ip"=>hops[pos]["ipaddr"]}, pos+1])
        if hops[pos+1]
          tuples.push([{"ip"=>hops[pos]["ipaddr"]},{"ip"=>hops[pos+1]["ipaddr"]}, pos+2])
        end
      else
        if hops[pos+1]
          tuples.push([{"ip"=>hops[pos]["ipaddr"]},{"ip"=>hops[pos+1]["ipaddr"]}, pos+3])
        end
      end
    end
    return tuples
  end

  def add_to_routes(hops)
    tuples = create_tuples(hops)

    for pos in (0..tuples.length) do
      next if not tuples[pos]
      next if tuples[pos][1]["ip"] == "0.0.0.0"
      current_child = check_children(@traceroutes,tuples[pos][1]["ip"])
      next if tuples[pos][0]["ip"] == "127.0.0.1" and current_child

      if(@traceroutes["children"].length == 0)
        @traceroutes["children"].push({"ip"=>tuples[pos][1]["ip"],"depth"=>tuples[pos][2],"children"=>[]})
      elsif(tuples[pos][0]["ip"] == "127.0.0.1" and !current_child)
        @traceroutes["children"].push({"ip"=>tuples[pos][1]["ip"],"depth"=>tuples[pos][2],"children"=>[]})
      else
        @traceroutes = find_location(tuples[pos],@traceroutes)
      end
    end
  end

  def find_location(tuple,root)
    return root if not root["children"]
    for pos in (0..root["children"].length)
      next if not tuple[0] or not root["children"][pos]
      if tuple[0]["ip"] == root["children"][pos]["ip"]
        is_child = check_children(root["children"][pos],tuple[1]["ip"])
        if !is_child
          grandchild = {"ip"=>tuple[1]["ip"],"depth"=>root["children"][pos]["depth"].to_i + 1,"children"=>[]}
          root["children"][pos]["children"].push(grandchild)
          return root
        end
      else
        root["children"][pos] = (find_location(tuple,root["children"][pos]))
      end
    end
    return root
  end

  def check_children(root,ip)
    return false if not root["children"]
    root["children"].each do |child|
      next if not child
      if child["ip"] == ip
        return true
      end
    end
    return false
  end

  def add_route_data(host,root)
    return root if not root["children"]
    for pos in (0..root["children"].length)
      next if not root["children"][pos]
      if host.address == root["children"][pos]["ip"]
        root["children"][pos]["os_name"] = host.os_name
        root["children"][pos]["os_flavor"] = host.os_flavor
        root["children"][pos]["mac"] = host.mac
        root["children"][pos]["comments"] = host.comments
        root["children"][pos]["name"] = host.name
        root["children"][pos]["id"] = host.id
        root["children"][pos]["status"] = host.status
        return root
      else
        root["children"][pos] = add_route_data(host,root["children"][pos])
      end
    end
    return root
  end

  def load_host
    @host = Mdm::Host.find(params[:id])
    @host.analyze_results
    @exploits = build_exploit_match
  end

  # Shows on 'Modules' tab of the Host show view
  def build_exploit_match
    exploits = @host.module_details.where(
      :mtype => [
        'auxiliary',
        'exploit'
      ]
    )

    exploits.collect do |record|
      details = Hosts::ModuleDetailPresenter.new(record)
      details.analysis(@host.analyze_results[record.fullname])
      details
    end
  end

  def hosts_params
    params.require(:host).permit!
  end

  def aadata_params
    params.require(:aaData).permit!
  end
end
