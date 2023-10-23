class AddFileUploadToScheduledTask < ActiveRecord::Migration[4.2]
  def change
    add_column :scheduled_tasks, :file_upload, :string
  end
end
