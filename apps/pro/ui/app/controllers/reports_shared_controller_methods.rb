module ReportsSharedControllerMethods

  #
  # Custom reports
  #

  def collect_report_custom_resources
    @report_custom_resources = @workspace.report_custom_resources
    @report_custom_templates = @report_custom_resources.templates
    @report_custom_logos     = @report_custom_resources.logos
  end


  def build_sanitized_report(report_params={})
    report_params = report_params.merge(:workspace_id => @workspace.id)
    report = Report.new(report_params)
    report.created_by = current_user.username
    # TODO Should include users that performed related actions
    report.usernames_reported = current_user.username
    # TODO Serialized field issues, remove empty
    # items so validation works:
    report.options.delete('') if report.options
    report.file_formats.delete('') if report.file_formats
    report.sections.delete('') if report.sections
    report
  end

end