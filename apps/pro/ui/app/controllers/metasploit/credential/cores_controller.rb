class Metasploit::Credential::CoresController < ApplicationController
  # TODO: Rewrite the save_manual matchers to use Metasploit::Model::Search.

  #
  # Model Scopes
  # originating_host_id must be the first scope defined because the subquery will pick up scopes defined before it
  #
  has_scope :originating_host_id, as: :host_id, if: :originating_creds_on_host?
  has_scope :workspace_id
  has_scope :with_ids
  has_scope :ids_only, type: :boolean
  has_scope :group_id

  include TableResponder
  include FilterResponder
  include Metasploit::Pro::Report::Utils
  include Metasploit::Credential::Creation
  include CredentialsHelper

  before_action :load_workspace
  before_action :load_core, only: [:destroy]
  before_action :set_js_routes, only: [:index]


  def index
    respond_to do |format|
      format.html
      format.any(:json, :csv) do
        respond_with_table(
          Metasploit::Credential::Core,
          includes: [:logins, :private, :public, :realm, :tags],
          include:  [:private, :public, :realm, :tags],
          presenter_class: Metasploit::Credential::CorePresenter,
          search: params[:search],
          selections: (params[:selections] || {}).merge(ignore_if_no_selections: true)
        )
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json do
        core = Metasploit::Credential::Core.where(id: params[:id]).
            includes([:private,:public, :realm, :tags]).first()

        render :json => Metasploit::Credential::CorePresenter.new(core).as_json
      end
    end
  end


  def create
    respond_to do |format|
      format.json do
        if import_request?
          import_creds
        else
          if login_request?
            save_manual_cred({login:true})
          else
            save_manual_cred
          end
        end
      end
    end
  end

  def destroy
    @core.destroy
    render json: { success: true }
  end

  def destroy_multiple
    # We have to hydrate every object to destroy it, to ensure that the dependent objects
    # are also destroyed and that any after_destroy callbacks happen.
    delete_credentials(params)
  end

  def export
    filename = params[:filename].nil? ? 'credentials' : sanitize_filename(params[:filename])

    if params[:export_format] == 'csv'
      exporter = Metasploit::Credential::Exporter::Core.new(workspace: @workspace, mode: :core)

      if params[:rows] == 'selected'
        selected_ids = selected_records(Metasploit::Credential::Core.where(workspace_id: @workspace.id), params[:selections]).select(:id).collect(&:id)
        exporter.whitelist_ids = selected_ids
      end

      exporter.export!

      send_file exporter.output_zipfile_path, filename: filename + '.zip'
    else
      exporter = Metasploit::Credential::Exporter::Pwdump.new
      exporter.workspace = @workspace

      send_data exporter.rendered_output, type: 'text/plain', filename: filename + '.txt'
    end
  end


  def quick_multi_tag
    selected_cores = load_filtered_records(Metasploit::Credential::Core, params)

    render json: TagCreator.build(
        params, Metasploit::Credential::Core, relation: selected_cores)
  end


  def tags
    core = Metasploit::Credential::Core.select(:id).includes(:tags).where(workspace_id:@workspace, id:params[:id]).last
    render json: core.as_json(include: :tags), status: :ok
  end

  def remove_tag
    tag_id = params[:tagId]

    @core = Metasploit::Credential::Core.where(workspace_id: @workspace.id, id: params[:id]).last

    @tag =Mdm::Tag.where(id: tag_id).last
    @tag.credential_cores.delete @core

    @tag.destroy if @tag.all_empty?

    respond_to do |format|
      format.json do
        render :json => {tags: @core.tags} , status: :ok
      end
    end

  end

  def filter_values
    scope = params['prefix']
    column = params['column']

    filter_ssh_private_data! if (scope == 'private' && column == 'data' && params[:search][:custom_query])

    # TODO: Fix the n+1 here (check the logs) with the judicious use of joins
    values = filter_values_for_key(Metasploit::Credential::Core, params)
    render json: values.as_json
  end

  private

  def import_creds
    import_credentials(params)
  end

  def save_manual_cred(opts={})
    private_type = case params[:private][:type]
                      when 'ssh'
                        :ssh_key
                      when 'plaintext'
                        :password
                      when 'ntlm'
                        :ntlm_hash
                      when 'hash'
                        :nonreplayable_hash
                      when 'none'
                        nil
                      else
                        :password
                    end
    cred_opts = {
        origin_type: :manual,
        user_id: @current_user.id,
        workspace_id: @workspace.id,
        username: params[:public][:username]
    }

    cred_opts.merge!({private_type: private_type, private_data: params[:private][:data]}) unless private_type.nil?
    cred_opts.merge!({realm_key: params[:realm][:key],realm_value: params[:realm][:value]}) unless params[:realm][:key] == 'None'

    begin
      core = create_credential(cred_opts)
    rescue ActiveRecord::RecordInvalid => e
      core = e.record
    end

    if core.valid?
      tag_params = {}
      if params[:tags] && !params[:tags].empty?
        tag_params = params[:tags]
      end
      tag_params[:entity_ids] = [core.id]
      TagCreator.build(tag_params, Metasploit::Credential::Core)

      if opts[:login]
        service = Mdm::Service.where(id: params[:login][:service]).first

        login_opts = {
            core: core,
            access_level: params[:login][:access_level],
            port: service.try(:port),
            service_name: service.try(:name),
            protocol: service.try(:proto),
            workspace_id: @workspace.id,
            address: service.try(:host).try(:address),
            status: Metasploit::Model::Login::Status::UNTRIED
        }

        begin
          login = create_credential_login(login_opts)
        rescue ActiveRecord::RecordInvalid => e
          login = e.record
        end

        #Also Tag the Login
        if login.valid?
          tag_params[:entity_ids] = [login.id]
          TagCreator.build(tag_params, Metasploit::Credential::Login)
        else

          errors = [
              {core:{base:['requires that a host contain a service']}}
          ]

          render :json => {success: false, :error=> errors, :status => :bad_request}
          return
        end

      end

      render :json => {success: true}
    else
      render_invalid core
    end
  end


  def create_manual_login(core_id,opts)
    login = Metasploit::Credential::Login.new
    login.access_level = opts[:access_level]
    login.service_id = opts.key?(:service) ? opts[:service] : nil
    login.core_id = core_id
    login.status = Metasploit::Model::Login::Status::UNTRIED

    if login.valid?
      login.save
    else
      login.errors
    end
  end

  # @return [Boolean] true if an import is being attempted, false otherwise
  def import_request?
    params[:cred_type] == 'import'
  end

  # @return [Boolean] true if an core with a login is being attempted, false otherwise
  def login_request?
    params[:cred_type] == 'login'
  end



  def render_invalid(core)
    case core
      when Metasploit::Credential::Core
        core_errors = core.errors.as_json
      when Metasploit::Credential::Realm
        realm_errors = core.errors.as_json
      when Metasploit::Credential::Public
        public_errors = core.errors.as_json
      else
        private_errors = core.errors.as_json
    end


    errors = [
      { core:    core_errors || {} },
      { realm:   realm_errors || {} },
      { public:  public_errors || {} },
      { private: private_errors || {} }
    ]

    if import_request?
      #Need to set partial format to HTML and Content Type manually because we are in a JSON format block. Needed for iframe Transport
      render :partial => 'shared/iframe_transport_response', :locals => { :data => { :success => false, :error => errors }}, formats: [:html], content_type: 'text/html'
    else
      render :json => {success: false, :error=> errors}, :status => :bad_request
    end
  end

  # Lazily sets the @core ivar to the core specified by the :id parameter
  def load_core
    @core ||= Metasploit::Credential::Core.find(params[:id])
  end

  def load_host
    @host ||= Mdm::Host.find(params[:host_id])
  end

  # @return [Boolean] the user wants to query a collection of Cores that have
  #   been collected off of a specific Host
  def originating_creds_on_host?
    params[:host_origin] == :originating
  end

  def lookup_by_group?
    params[:group_id].present?
  end

  # Sets the @workspace ivar to the Mdm::Workspace that this Core belongs to
  # CoresController#index is used from multiple routes:
  #
  #    /workspace/1/metasploit/credential/cores.json ->
  #      all Cores in workspace #1
  #
  #    /workspaces/2/brute_force/reuse/groups/1/cores.json ->
  #      all Cores in Group #1, which must belong to workspace #2
  #
  #    /hosts/1/metasploit/credential/cores/accessing.json ->
  #      all Cores that have been used to log into Host #1
  #
  #    /hosts/1/metasploit/credential/cores/originating.json ->
  #      all Cores that were collected from Host #1
  #
  # Different parameters are used by :has_scope to ensure the correct scopes are applied


  def load_workspace
    if params.has_key? :host_id
      params[:workspace_id] = load_host.workspace.id
    elsif params.has_key? :id
      raise ActiveRecord::RecordNotFound unless core_workspace_valid?
    end
    super
  end

  def core_workspace_valid?
    load_core.workspace_id == params[:workspace_id].to_i
  end

  def set_js_routes
    gon.destroy_multiple_workspace_metasploit_credential_cores_path =
      destroy_multiple_workspace_metasploit_credential_cores_path(@workspace)

    gon.export_workspace_metasploit_credential_cores_path =
      export_workspace_metasploit_credential_cores_path(@workspace)

    gon.filter_values_workspace_metasploit_credential_cores_path =
      filter_values_workspace_metasploit_credential_cores_path(@workspace)

    gon.filter_values_workspace_brute_force_reuse_targets_path =
        filter_values_workspace_brute_force_reuse_targets_path(@workspace)
  end

  # TODO: this is a hack to filter out private data where type is an SSH key, used in #filter_values
  # Since Metasploit::Model::Search uses a union on duplicate key:value pairs
  # we can can merge into params[:search][:custom_query] every private.type except ssh key
  # Need a better way to do this
  # TODO: need to place this somewhere else if we want to re-use in other tables
  # (ex. usually any table of Hosts)
  def filter_ssh_private_data!
    unless params[:search][:custom_query].include?("private.type")
      params[:search][:custom_query] << " private.type:'Metasploit::Credential::NTLMHash'"
      params[:search][:custom_query] << " private.type:'Metasploit::Credential::NonreplayableHash'"
      params[:search][:custom_query] << " private.type:'Metasploit::Credential::Password'"
    end
  end
end
