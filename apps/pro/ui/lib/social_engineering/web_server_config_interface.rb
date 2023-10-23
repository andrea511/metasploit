module SocialEngineering::WebServerConfigInterface
  extend ActiveSupport::Concern

  include SocialEngineering::Port

  #
  # CONSTANTS
  #

  DEFAULT_WEB_PORT     = 80
  DEFAULT_WEB_BAP_PORT = 8081
  WEB_SSL_VERSIONS     = ['SSL2', 'SSL3', 'TLS']

  included do
    extend MetasploitDataModels::SerializedPrefs

    #
    # Serialized Preferences - ordered by name
    #

    serialized_prefs_attr_accessor :web_ssl
    serialized_prefs_attr_accessor :web_host
    serialized_prefs_attr_accessor :web_port
    serialized_prefs_attr_accessor :web_bap_port
    serialized_prefs_attr_accessor :web_username
    serialized_prefs_attr_accessor :web_password

    #
    #
    # Validations - ordered by attribute name
    #
    #

    #
    # web_bap_port
    #

    validates_port :web_bap, 'Web BAP'

    #
    # web_port
    #

    validates_port :web

    validates :web_host, :presence => true
  end

  #
  # Instance Methods - ordered by name
  #

  def web_configured?
    web_host.present? && web_port.present?
  end
end


