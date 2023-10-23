class Wizards::BaseController < ApplicationController
  before_action :load_steps, only: [:show]

  # Wizard autogenerates the routes for each step of the wizard
  include Wicked::Wizard

  # don't need a layout as we're passing HTML over AJAX
  layout false

  # needs to be overriden in a subclass to render the form in HTML
  def show
    raise NotImplementedError, "#show needs to be overriden in a subclass."
  end

  # needs to be overriden in a subclass to validate the form
  # renders a JSON hash with a :success attribute
  def validate
    raise NotImplementedError, "#validate needs to be overriden in a subclass."
  end

  # needs to be overriden in a subclass to validate the form and launch the commander
  # renders a JSON hash with a :success=>false attribute if invalid input
  # renders a JSON hash with a :path=> attribute to redirect to if commander is launched
  def launch
    raise NotImplementedError, "#launch needs to be overriden in a subclass."
  end

  # hand over control to the validate method
  def update
    validate
  end

  # hand over control to the launch method
  def create
    launch
  end
 
  protected

  # Makes the @steps and @current_step ivars available to the form
  def load_steps
    @steps = steps
    @current_step = step
  end

  # @return [Boolean] if request was made by POSTing into an iframe. We
  #  use this to upload files in an AJAXy way in IE9. We need to handle the
  #  response a little differently.
  def iframe_request? # of course, ie sends the header key in downcase. ughhh.
    req_with = request.headers['X-Requested-With'] || request.headers['x-requested-with'] ||
               request.env['X-Requested-With']     || request.env['x-requested-with']
    not (req_with =~ /xmlhttprequest/i)
  end

  # renders the errors from the given Wizards::BaseValidator subclass instance
  #   and renders the errors in an HTML partial or a JSON blob, depending on transport.
  # @param validator [Wizards::BaseValidator] has an #errors attribute
  def render_errors_from_validator(validator)
    render_errors(validator.errors_hash)
  end

  # renders the errors from the given Wizards::BaseValidator subclass instance
  #   and renders the errors in an HTML partial or a JSON blob, depending on transport.
  # @param errors [Hash] of key/value data
  def render_errors(errors={})
    if iframe_request?
      # we use 'pass_data' partial to enable passing JSON back to the user.
      # the JSON is wrapped in <textarea> tags to fix an IE9
      #   annoyance related to doing AJAXy file uploads.
      # (unfortunately this IE bug also means we can't get a SUCCESS or ERROR condition
      #   client-side from http, so we use {success=>true} as a crappy workaround)
      render :partial => 'shared/iframe_transport_response', :locals => { :data => {
        :success => false, :errors => errors
      }}
    else
      render :json => { :success => false, :errors => errors }
    end
  end

  # renders {:success=>true} in an HTML partial or a JSON blob, depending on transport.
  # @param [Hash] options more data to pass back to the user
  def render_success(options={})
    if iframe_request?
      render :partial => 'shared/iframe_transport_response', :locals => { :data => { :success => true }.merge(options) }
    else
      render :json => { :success => true }.merge(options)
    end
  end
end
