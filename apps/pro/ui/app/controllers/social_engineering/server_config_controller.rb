module SocialEngineering
class ServerConfigController < ApplicationController
  before_action :find_campaign
  before_action :load_workspace

  # Assume we're doing AJAXy stuff that will render w/out layout
  respond_to :js
  layout false


  # Since we're just rendering the default template, the controller-wide 
  # respond_to takes care of anything we'd need to do here.
  def edit
  end

  # adjust controller response to account for bad requests.
  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
    error = {}
    error[parameter_missing_exception.param] = ['parameter is required']
    response = { errors: [error] }
    render json: response, status: :unprocessable_entity
  end

  private

  def find_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end
end
end
