class AddFormatToReportArtifactAndRemoveItFromReports < ActiveRecord::Migration[4.2]
	def up
		add_column :report_artifacts, :format, :string
		ReportArtifact.reset_column_information
		ReportArtifact.find_each do |report_artifact|
			report_artifact.update(format: report_artifact.file_format)
		end
	end
	def down
		remove_column :report_artifacts, :format
	end
end
