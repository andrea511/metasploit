class ModulesController < ApplicationController
  before_action :load_workspace
  before_action :using_embedded_layout?
  layout :task_layout_selector

  include TableResponder

  has_scope :workspace_id, only: [:index]

  # parameters: (if no params are passed, return the top 10 modules)
  #   q -> query to search for
  #   extra_query -> an additional string to append to query
  #   straight    -> skip the 'return top 10', spit back all matching modules
  #   file_format -> return only file format exploits
  def index
    @q       = params[:q].to_s.downcase
    if params[:file_format].blank?
      @all_modules = MsfModule.all.reject {|m| m.file_format_exploit? }
    else
      @all_modules = MsfModule.all.select {|m| m.file_format_exploit? }
    end

    sort_by = params[:sort_by] || 'disclosure'
    sort_dir = params[:sort_dir] || 'asc'

    unless License.get.supports_agent?
      @all_modules.reject! {|x| x.fullname =~ /\/pro\/.*agent.*/ }
    end

    unless License.get.supports_macros?
      @all_modules.reject! {|x| x.fullname  =~ /\/pro\/.*macro.*/ }
    end

    extra_query = params[:extra_query] || ''
    @modules = if @q.blank? && extra_query.blank? && params[:straight].blank?
      @all_modules.select {|m| m.disclosure_date }.sort_by(&:disclosure_date).reverse[0,10]
    else
      keywords = parse_search_terms("#{@q} #{extra_query}")
      @all_modules.reject {|m| m.filter(keywords) }
    end

    @modules = sort_modules(@modules, sort_by, sort_dir)

    @stat_modules_total      = @all_modules.size
    @stat_modules_exploit    = MsfModule.exploits.size
    @stat_modules_auxiliary  = MsfModule.auxiliary.size
    @stat_modules_post       = MsfModule.post.size
    @stat_modules_server     = @all_modules.select{|m| m.server_exploit? }.size
    @stat_modules_client     = @all_modules.select{|m| m.client_exploit? }.size

    @hosts = if params[:host_ids]
      @workspace.hosts.find( params[:host_ids] )
    elsif params[:selections]
      records = records_from_selection_params( params[:class], params[:selections] )

      unless records.first.try(:class) == Mdm::Host
        records = records.collect( &:host )
      end

      records.compact.uniq
    else
      []
    end

    render layout: !request.xhr?
  end

  def refresh
    MsfModule.reload_modules
  end

  def show
    @module = MsfModule.find_by_fullname(params[:path].join('/'))
  end

protected

  def parse_search_terms(q)

    q += " "
    # Split search terms by space, but allow quoted strings
    terms = q.split(/\"/).collect{|t| t.strip==t ? t : t.split(' ')}.flatten
    terms.delete('')

    # All terms are either included or excluded
    res = {}

    terms.each do |t|
      f,v = t.split(":", 2)
      if not v
        v = f
        f = 'text'
      end
      next if v.length == 0
      f.downcase!
      v.downcase!
      res[f] ||=[   [],    []   ]
      if v[0,1] == "-"
        next if v.length == 1
        res[f][1] << v[1,v.length-1]
      else
        res[f][0] << v
      end
    end
    res
  end

  def sort_modules(modules, sort_by, sort_dir)
    desc = sort_dir == 'desc'

    sort_proc = case sort_by
    when 'title'
      sort_modules_by(modules, desc) { |m| m.title.downcase }
    when 'disclosure'
      sort_modules_by(modules, desc) { |m| m.disclosure_date }
    when 'privileged'
      sort_modules_by(modules, desc) { |m| m.privileged ? 1 : 0 }
    when 'rank'
      sort_modules_by(modules, desc) { |m| m.rank }
    when 'type'
      sort_modules_by(modules, desc) { |m| m.type }
    else
      sort_modules_by(modules, desc) { |h| h.title.downcase }
    end
  end

  # sort the modules using the given block, always putting blanks at the end
  def sort_modules_by(modules, descending, &block)
    blank, non_blank = modules.partition do |h|
      val = yield(h)
      val.nil? or val == "" or val == 0
    end

    if descending
      non_blank.sort { |a,b| yield(a) <=> yield(b) } + blank
    else
      non_blank.sort { |c,d| yield(d) <=> yield(c) } + blank
    end
  end


end

