class ImportsController < ApplicationController
  before_action :load_workspace
  before_action :load_consoles

  def new
    gon.licensed = License.get.supports_sonar?

    respond_to do |format|
      format.html
    end
  end

  private

  # @return [Hash<String, Integer>] map of Nexpose Console name -> Console ID
  # for rendering as an HTML <select> collection
  def load_consoles
    gon.consoles = Mdm::NexposeConsole.order('created_at DESC')
      .each_with_object({}) { |c, obj| obj[c.name] = c.id }
    gon.addresses = @workspace.addresses
  end

end
