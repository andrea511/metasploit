# ANY CHANGES MADE HERE MUST BE REPLICATED IN _report.jbuilder
json.id report_artifact.id
json.file_format report_artifact.file_format
json.artifact_file_exists report_artifact.artifact_file_exists
json.not_generated false
json.status 'complete'
json.url view_workspace_report_report_artifact_path(report_artifact.report.workspace, report_artifact.report, report_artifact)
json.download_url download_workspace_report_report_artifact_path(report_artifact.report.workspace, report_artifact.report, report_artifact)
json.pretty_created_at report_artifact.pretty_created_at
json.pretty_accessed_at report_artifact.pretty_accessed_at
