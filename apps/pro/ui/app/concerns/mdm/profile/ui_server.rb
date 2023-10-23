# class name here must match default zeitwerk convention due to extending
# a class managed by the framework context.
module Mdm::Profile::UiServer
  extend ActiveSupport::Concern

  def ui_server_settings
    UIServerSettings.new(settings.to_hash)
  end
end
