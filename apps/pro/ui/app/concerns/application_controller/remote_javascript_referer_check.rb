# This patch adds a before_action to all controllers that prevents xdomain
# .js requests from being rendered successfully.
module ApplicationController::RemoteJavascriptRefererCheck
  extend ActiveSupport::Concern

  included do
    require 'uri'
    before_action :check_rjs_referer, :if => ->(controller) { controller.request.format.js? }
  end

  # prevent generated rjs scripts from being exfiltrated by remote sites
  # see http://homakov.blogspot.com/2013/11/rjs-leaking-vulnerability-in-multiple.html
  def check_rjs_referer
    referer_uri = begin
      URI.parse(request.env["HTTP_REFERER"])
    rescue URI::InvalidURIError
      nil
    end

    # if request comes from a cross domain document
    if referer_uri.blank? or
      (request.host.present? and referer_uri.host != request.host) or
      (request.port.present? and referer_uri.port != request.port)

      head :unauthorized
    end
  end
end
