class MigrateLegacyImportTaskChainTasks < ActiveRecord::Migration[4.2]
  def up
    legacy_import_tasks = ScheduledTask.where(kind: [:import,:nexpose])
    #Migtate each legacy import to a blank import config
    legacy_import_tasks.each do |task|
      case task.kind.to_sym
        when :import
          unless task.file_upload.current_path.nil?
            migrate_file_import task
          else
            migrate_site_import task
          end
        when :nexpose
          migrate_scan_and_import task
      end
      task.save(validate:false)
    end
  end

  private

  def migrate_file_import(task)
    task.legacy = true
    task.config_hash = {

    }
    task.form_hash = {
      "migrated" => "true"
    }
  end

  def migrate_site_import(task)
    task.kind = :scan_and_import
    task.legacy = true
    task.config_hash = {
    }
    task.form_hash = {
      "migrated" => "true",
      "sites" => []
    }
  end

  def migrate_scan_and_import(task)
    task.kind = :scan_and_import
    task.legacy = true
    task.config_hash = {
    }
    task.form_hash = {
      "migrated" => "true",
      "scan" => "true"
    }
  end

end
