class Metasploit::Credential::OriginsController < ApplicationController
  before_action :load_workspace
  before_action :load_credential_core

  def show
    respond_to do |format|
      format.html
      format.json do
        render json: Metasploit::Credential::OriginPresenter.new(@credential_core.origin).to_json
      end
    end
  end

  private

  def load_credential_core
    @credential_core = @workspace.core_credentials.find(params[:core_id])
  end
end
