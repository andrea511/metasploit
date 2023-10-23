json.id @report.id
json.name @report.name
json.state @report.state
json.file_formats @report.file_formats
json.allowed_file_formats @report.rtype.formats
json.pretty_report_type @report.pretty_report_type
json.pretty_created_at @report.pretty_created_at
json.created_by @report.usernames_reported

json.sections @report.pretty_section_names do |section|
  json.name section
end

json.options @report.pretty_option_names do |option|
  json.name option
end

json.included_addresses @report.included_addresses_array
json.excluded_addresses @report.excluded_addresses_array

# TODO: We're duplicating the contents of the report_artifact partial here due
# to this bug in gon: https://github.com/gazay/gon/issues/54
# A fix will likely require forking gon and fixing the bug, as gon's support for
# jbuilder is quite wonky, indeed.
json.report_artifacts @report.pretty_report_artifacts do |report_artifact|
  # ANY CHANGES MADE HERE MUST BE REPLICATED IN THE _report_artifact.jbuilder PARTIAL
  json.id report_artifact.id
  json.file_format report_artifact.file_format
  json.artifact_file_exists report_artifact.artifact_file_exists
  json.not_generated false
  json.status 'complete'
  json.url view_workspace_report_report_artifact_path(report_artifact.report.workspace, report_artifact.report, report_artifact)
  json.download_url download_workspace_report_report_artifact_path(report_artifact.report.workspace, report_artifact.report, report_artifact)
  json.pretty_created_at report_artifact.pretty_created_at
  json.pretty_accessed_at report_artifact.pretty_accessed_at
end