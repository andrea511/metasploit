class Metasploit::Credential::LoginsController < ApplicationController
  include TableResponder
  include Metasploit::Credential::Creation

  before_action :load_workspace
  before_action :load_credential_core, only: :index, unless: :accessing_logins_on_host?
  before_action :load_login, only: [:show, :update, :validate_authentication, :attempt_session]
  before_action :load_filtered_logins, only: [:quick_multi_tag, :destroy_multiple]

  has_scope :ids_only, type: :boolean
  has_scope :by_host_id, as: :host_id, if: :accessing_logins_on_host?

  def index
    respond_to do |format|
      format.html
      format.any(:json, :csv) do
        if accessing_logins_on_host?
          logins = Metasploit::Credential::Login
          presenter = Metasploit::Credential::LoginCorePresenter
        else
          logins = @credential_core.logins
          presenter =  Metasploit::Credential::LoginPresenter
        end

        respond_with_table(
          logins,
          # todo: would be nice if TableResponder handled these conversions.
          # :includes is for ActiveRecord::Relation#includes,
          # :include is for as_json
          includes: [{service: :host}, :tags],
          include: [{service: { include: :host }}, :tags],
          presenter_class: presenter
        )
      end
    end
  end

  def show
    respond_to do |format|
      format.json do
        respond_with Metasploit::Credential::LoginPresenter.new(@login).as_json(
          include: [service: { include: :host }],
          overwrite_service: false
        )
      end
    end
  end


  def create
    respond_to do |format|
      format.json do
        core = Metasploit::Credential::Core.where(id: params[:core_id]).first
        service = params.key?(:service) ? Mdm::Service.where(id:params[:service]).first : nil

        login_opts = {
            core: core,
            access_level: params[:access_level],
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

        if login.valid?
          params[:tags][:entity_ids] = [login.id]
          TagCreator.build(params[:tags], Metasploit::Credential::Login)

          render :json => {success: :ok}
        else
          render :json => {success: false, :error=>login.errors}, :status => :bad_request
        end

      end
    end
  end

  def update
    allowed_params = { access_level: params[:access_level] }
    @login.update(allowed_params)
    respond_to do |format|
      format.json do
        respond_with @login.as_json(
          include: [service: { include: :host }]
        )
      end
    end
  end

  def destroy_multiple
    begin
      @logins.destroy_all

      render json: { success: true }
    rescue
      render json: { success: false }
    end
  end

  def quick_multi_tag
    render json: TagCreator.build(params, Metasploit::Credential::Login, relation: @logins)
  end

  def tags
    login = Metasploit::Credential::Login.joins(:core).where(id:params[:id],metasploit_credential_cores:{workspace_id:@workspace.id}).last
    render json: login.as_json(include: :tags), status: :ok
  end

  def remove_tag
    tag_id = params[:tagId]

    login = Metasploit::Credential::Login.joins(:core).where(id:params[:id],metasploit_credential_cores:{workspace_id:@workspace.id}).last

    @tag =Mdm::Tag.where(id: tag_id).last
    @tag.credential_logins.delete login
    @tag.destroy if @tag.all_empty?

    respond_to do |format|
      format.json do
        render :json => {tags: login.tags} , status: :ok
      end
    end

  end


  def validate_authentication
    task_id = @login.validate_authentication

    respond_to do |format|
      format.json do
        render json: { task_id: task_id }
      end
    end
  end

  def attempt_session
    task_id = @login.attempt_session

    respond_to do |format|
      format.json do
        render json: { task_id: task_id}
      end
    end
  end

  def get_session
    session = Mdm::Session.select([Mdm::Session[:id],Mdm::Session[:desc]]).joins(
      Mdm::Session.join_association(:host),
      Mdm::Host.join_association(:services),
      Mdm::Service.join_association(:logins)
    ).where(
      metasploit_credential_logins:{id:params[:id]}
    ).alive.last

    respond_to do |format|
      format.json do
        render json: session
      end
    end
  end

  private

  def load_credential_core
    @credential_core = @workspace.core_credentials.find(params[:core_id])
  end

  def load_login
    @login = Metasploit::Credential::Login.find(params[:id])
  end

  def load_host
    @host ||= Mdm::Host.find(params[:host_id])
  end

  # @return [Boolean] the user wants to query a collection of Cores that have
  #   been used to log into a specific Host
  def accessing_logins_on_host?
    params[:host_origin] == :accessing
  end

  def load_workspace
    if params.has_key? :host_id
      @workspace = load_host.workspace
    else
      super
    end
  end

  def load_filtered_logins
    @logins = load_filtered_records(Metasploit::Credential::Login, params)
  end

end
