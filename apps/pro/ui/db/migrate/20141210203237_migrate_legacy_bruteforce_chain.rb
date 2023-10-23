class MigrateLegacyBruteforceChain < ActiveRecord::Migration[4.2]
  def up
    #So we can track a migrated task
    add_column :scheduled_tasks, :legacy, :boolean, default: false

    legacy_bruteforce_tasks = ScheduledTask.where(kind: :bruteforce)

    #Migtate each legacy bruteforce to a blank bruteforce config
    legacy_bruteforce_tasks.each do |task|
      task.config_hash = {stubbed:true}
      task.legacy = true
      task.form_hash = {
      "quick_bruteforce" => {
        "targets" => {
          "type" => "all",
          "whitelist_hosts" => "",
          "blacklist_hosts" => "",
          "all_services" => "false",
          "services" => {
            "AFP" => "false",
            "DB2" => "false",
            "FTP" => "false",
            "HTTP" => "false",
            "HTTPS" => "false",
            "MSSQL" => "false",
            "MySQL" => "false",
            "POP3" => "false",
            "Postgres" => "false",
            "SMB" => "false",
            "SNMP" => "false",
            "SSH" => "false",
            "SSH_PUBKEY" => "false",
            "Telnet" => "false",
            "VNC" => "false",
            "WinRM" => "false"
          }
        },
        "creds" => {
          "import_workspace_creds" => "false",
          "factory_defaults" => "false",
          "add_import_cred_pairs" => "false",
          "import_cred_pairs" => {
            "data" => "",
            "use_file_contents" => "",
            "blank_as_password" => "false",
            "username_as_password" => "false"
          }
        },
        "use_last_uploaded" => "",
        "options" => {
          "overall_timeout" => {
            "hour" => "4",
            "minutes" => "0",
            "seconds" => "0"
          },
          "service_timeout" => "900",
          "time_between_attempts" => "0",
          "mutation" => "false",
          "stop_on_guess" => "false",
          "payload_settings" => "false"
        }
      },
        "text_area_status" => "",
        "import_pair_count" => "",
        "text_area_count" => "",
        "file_pair_count" => "",
        "clone_file_warning" => "",
        "payloadModel" => "undefined",
        "mutationModel" => "undefined",
        "overall_timeout" => "14400",
        "workspace" => task.task_chain.workspace
      }

      task.save
    end

  end

  def down
  end
end
