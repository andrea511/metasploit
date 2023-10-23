class ReportPresenter < DelegateClass(Report)
  include ActionView::Helpers
  include Rails.application.routes.url_helpers

  # @return [String] the human-readable version of the report type
  def pretty_report_type
    rtype.name
  end

  # @return [Array<String>] the human-readable versions of the section names
  def pretty_section_names
    rtype.sections.collect { |key, val| val }
  end

  # @return [String] the human-readable created at timestamp
  def pretty_created_at
    l(created_at, format: :short_date)
  end

  # @return [Array<ReportArtifactPresenter>] returns the associated ReportArtifacts,
  #   run through the ReportArtifactPresenter
  def pretty_report_artifacts
    report_artifacts.collect { |report_artifact| ReportArtifactPresenter.new(report_artifact) }
  end

  # @return [String] the path to the report artifacts collection
  def artifacts_path
    remove_params(workspace_report_report_artifacts_path(workspace_id, self))
  end

  # @return [String] the email report path
  def email_path
    remove_params(email_workspace_report_report_artifacts_path(workspace_id, self))
  end

  # @return [String] the regeneration status path
  def regeneration_status_path
    remove_params(format_generation_status_workspace_report_path(workspace_id, self))
  end

  # @return [String] the format regeneration path
  def regenerate_format_path
    remove_params(generate_format_workspace_report_path(workspace_id, self))
  end

  private

  # Remove the URL params added by `link_to` due to the use of a presenter class.
  #
  # @param path [String] the path to sanitize
  #
  # @return [String] the sanitized path
  def remove_params(path)
    path.gsub(/\?.*$/, '')
  end
end