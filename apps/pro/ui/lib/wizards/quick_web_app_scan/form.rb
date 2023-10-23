# QuickPentest "faux" model for rendering the QuickPentest form.
# The idea behind the QuickPentest widget is to allow our sales guys
#   to launch Pro, click one button, enter an IP and immediately pwn
#   everything, so we need some really badass defaults.
module Wizards
module QuickWebAppScan
  class Form < Wizards::BaseForm
    include Metasploit::Pro::AttrAccessor::Boolean

    #
    # Constants
    #
    QUICK_WEB_APP_SCAN_REPORT_TYPES = [:webapp_assessment]
    QUICK_WEB_APP_SCAN_AUTH_TYPES = [:basic, :cookie]
    QUICK_WEB_APP_SCAN_TYPES = [:scan_now, :import]

    #
    # Nested models
    #
    attr_accessor :import_task
    attr_accessor :report
    attr_accessor :web_audit_task
    attr_accessor :web_scan_task
    attr_accessor :web_sploit_task
    attr_accessor :workspace

    # "glue" attributes that don't belong to one task
    attr_accessor :auth_enabled
    attr_accessor :auth_type
    attr_accessor :report_enabled
    attr_accessor :report_type
    attr_accessor :scan_type
    attr_accessor :web_audit_enabled
    attr_accessor :web_sploit_enabled

    def initialize(attrs={})
      super
      self.report_enabled = set_default_boolean(attrs[:report_enabled], false)
      self.web_audit_enabled = set_default_boolean(attrs[:web_audit_enabled], false)
      self.web_sploit_enabled = set_default_boolean(attrs[:web_sploit_enabled], false)
      self.auth_enabled = set_default_boolean(attrs[:auth_enabled], false)
      self.scan_type ||= QUICK_WEB_APP_SCAN_TYPES.first
      self.auth_type ||= QUICK_WEB_APP_SCAN_AUTH_TYPES.first
    end

    def scans?
      scan_type.to_sym == :scan_now
    end

    def imports?
      scan_type.to_sym == :import
    end
  end
end
end
