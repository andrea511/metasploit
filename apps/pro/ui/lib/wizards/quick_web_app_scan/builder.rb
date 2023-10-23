module Wizards
module QuickWebAppScan
  class Builder < Wizards::BaseBuilder
    # @param [Hash] params the params passed straight from the controller
    # @param [Mdm::User] user the current_user
    def initialize(params, user)
      self.form = Wizards::QuickWebAppScan::Form.new(params[:quick_web_app_scan] || {})
      # remove http cookie, http username and http password if auth_enabled is false
      if not form.auth_enabled
        params[:web_scan_task] ||= {}
        params[:web_scan_task].delete :http_username
        params[:web_scan_task].delete :http_password
        params[:web_scan_task].delete :cookie
      end
      super
    end

    # returns an initialized QuickWebAppScan instance determined by params
    #
    # @return [Wizards::QuickWebAppScan::Form] with populated attributes
    def build
      # build all of the inner models
      build_workspace_from_params
      build_import_task_from_params
      build_web_scan_task_from_params
      build_web_audit_task_from_params
      build_web_sploit_task_from_params
      build_report_from_params
      # return our new model
      form
    end

    # After calling .build, to_procedure lets you output the snowballed
    # config to a Wizards::QuickWebAppScan::Procedure
    #
    # @return [Wizards::QuickWebAppScan::Procedure] an initialized Procedure
    #   with a populated config_hash 
    def to_procedure
      p = Wizards::QuickWebAppScan::Procedure.new(:config_hash => form.to_hash)
      p.workspace = form.workspace
      p.user = current_user
      p
    end

    # Sets default UI options for the user that never drills
    #   down into the "Advanced" fieldsets.
    #
    # @return [Wizards::QuickWebAppScan::Builder] self
    def set_defaults!
      form.workspace = Mdm::Workspace.new({
        :boundary => default_ip_range,
        :limit_to_network => true
      })
      form.web_scan_task = WebscanTask.new({
        :workspace => form.workspace,
        :username => current_user.username
      })
      form.web_audit_task = WebauditTask.new({
        :workspace => form.workspace,
        :username => current_user.username
      })
      form.web_sploit_task = WebsploitTask.new({
        :workspace => form.workspace,
        :username => current_user.username
      })
      form.report = Report.new({
        :skip_data_check    => true,
        :report_type        => Wizards::QuickWebAppScan::Form::QUICK_WEB_APP_SCAN_REPORT_TYPES[0],
        :file_formats       => [Report::DEFAULT_FILE_FORMAT],
        :options            => Report::DEFAULT_OPTIONS,
      })
      form.import_task = ImportTask.new({
        :workspace => form.workspace
      })
      form.report_enabled = true
      form.web_sploit_enabled = true
      form.web_audit_enabled = true
      form.auth_enabled = false
      form.scan_type = :scan_now
      self
    end

    private

    def build_report_from_params
      super(:report_type => Wizards::QuickWebAppScan::Form::QUICK_WEB_APP_SCAN_REPORT_TYPES[0],
            :included_addresses => form.workspace.boundary) if form.report_enabled
    end

    def build_web_scan_task_from_params
      if form.scans?
        form.web_scan_task = WebscanTask.new(
          (params[:web_scan_task] || {}).merge({
            :workspace => form.workspace,
            :username => current_user.username
          })
        )
      end
    end

    def build_import_task_from_params
      if form.imports?
        super
      end
    end

    def build_web_audit_task_from_params
      if form.web_audit_enabled
        form.web_audit_task = WebauditTask.new(
          (params[:web_audit_task] || {}).merge({
            :workspace => form.workspace,
            :username => current_user.username,
            :urls => urls_to_scan,
            :skip_urls_check => true,
          }).merge(http_scan_options)
        )
      end
    end

    def build_web_sploit_task_from_params
      if form.web_audit_enabled and form.web_sploit_enabled
        form.web_sploit_task = WebsploitTask.new(
          (params[:web_sploit_task] || {}).merge({
            :workspace => form.workspace,
            :username => current_user.username,
            :urls => urls_to_scan,
            :skip_vuln_check => true
          }).merge(http_scan_options)
        )
      end
    end

    # @return [String] the URLs to scan passed in by the user
    def urls_to_scan
      web_scan_params = params[:web_scan_task] || {}
      web_scan_params[:urls] || ''
    end

    # return [Hash] of http_username, http_password, and cookie data
    def http_scan_options
      params[:web_scan_task] ||= {}
      if form.auth_enabled
        {
          :http_username => params[:web_scan_task][:http_username],
          :http_password => params[:web_scan_task][:http_password],
          :cookie => params[:web_scan_task][:cookie]
        }
      else
        {}
      end
    end
  end
end
end
