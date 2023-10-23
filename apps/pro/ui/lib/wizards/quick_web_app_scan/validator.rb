module Wizards
module QuickWebAppScan
  class Validator < Wizards::BaseValidator

    # returns false if workspace[] parameters are invalid
    # @return [Boolean]
    def create_project_valid?
      workspace_valid = form.workspace.valid?
      if form.scans?
        web_scan_valid  = form.web_scan_task.valid?
        workspace_valid and web_scan_valid
      else
        import_valid    = form.import_task.valid?
        workspace_valid and import_valid
      end
    end

    # returns false if the user has enabled WebSploit task
    #   but misconfigured it somehow
    # @return [Boolean]
    def configure_authentication_valid?
      true # user doesn't have room to screw this up, phew.
    end

    # returns false if the user has enabled WebAudit task
    #   but misconfigured it somehow
    # @return [Boolean]
    def configure_web_audit_valid?
      if form.scans? and form.web_audit_enabled
        form.web_audit_task.valid?
      else
        true
      end
    end

    # returns false if the user has enabled WebSploit task
    #   but misconfigured it somehow
    # @return [Boolean]
    def configure_web_sploit_valid?
      if form.scans? and form.web_audit_enabled and form.web_sploit_enabled
        form.web_sploit_task.valid?
      else
        true
      end
    end

    # returns false if the user has enabled Report
    #   but misconfigured it somehow
    # @return [Boolean]
    def generate_report_valid?
      if form.report_enabled
        form.report.valid?
      else 
        true 
      end
    end

    # @return [Hash<String => String, Hash>] of Form's attribute names => error messages
    def errors_hash
      {
        :workspace => form.workspace.present? ? form.workspace.errors.messages : {},
        :web_scan_task => form.web_scan_task.present? ? form.web_scan_task.specific_error : {},
        :web_audit_task => form.web_audit_task.present? ? form.web_audit_task.specific_error : {},
        :web_sploit_task => form.web_sploit_task.present? ? form.web_sploit_task.specific_error : {},
        :report => form.report.present? ? form.report.errors : {},
        :import_task => form.import_task.present? ? form.import_task.specific_error : {}
      }
    end
  end
end
end