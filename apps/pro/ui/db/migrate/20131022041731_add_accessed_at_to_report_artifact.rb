class AddAccessedAtToReportArtifact < ActiveRecord::Migration[4.2]
  def change
    add_column :report_artifacts, :accessed_at, :timestamp
  end
end
