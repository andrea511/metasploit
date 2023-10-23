class RestApi::V1::BaseController < ActionController::Base

  # Ensure we return a 403 if an APIKey object is not found
  before_action :require_api_key

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # Simple token check - returns HTTP 200 unless caught by filter
  def index
    head :ok
  end

  # Provide has_scope and Kaminari-based functionality for pagination in all subclasses
  def self.inherited(subclass)
    super
    subclass.instance_eval do
      has_scope :page, default: 1
      has_scope :per, as: :per_page, default: 100
    end
  end


  private

  # Returns HTTP 403 unless API token in header is valid
  def require_api_key
    head :forbidden unless Mdm::ApiKey.where(token: request.headers['HTTP_TOKEN']).exists?
  end

  # Common behavior for any time we can't find something in API classes
  def record_not_found
    head :not_found
  end

  # adjust controller response to account for bad requests.
  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
    error = {}
    error[parameter_missing_exception.param] = ['parameter is required']
    response = { errors: [error] }
    render json: response, status: :unprocessable_entity
  end
end
