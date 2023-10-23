class ChangeNexposeFacingStringColumnsToText < ActiveRecord::Migration[4.2]
  def change
    reversible do |dir|
      dir.up do
        change_table :nexpose_data_assets do |t|
          t.change :asset_id,     :text
          t.change :url,          :text
          t.change :os_name,      :text
          t.change :last_scan_id, :text
        end

        change_table :nexpose_data_exploits do |t|
          t.change :nexpose_exploit_id, :text
          t.change :skill_level,        :text
          t.change :source_key,         :text
          t.change :source,             :text
        end

        change_table :nexpose_data_import_runs do |t|
          t.change :state,        :text
          t.change :import_state, :text
        end

        change_table :nexpose_data_scan_templates do |t|
          t.change :scan_template_id, :text
          t.change :name,             :text
        end

        change_table :nexpose_data_sites do |t|
          t.change :site_id,      :text
          t.change :name,         :text
          t.change :importance,   :text
          t.change :type,         :text
          t.change :last_scan_id, :text
        end

        change_table :nexpose_data_vulnerabilities do |t|
          t.change :vulnerability_id, :text
          t.change :title,            :text
        end

        change_table :nexpose_data_vulnerability_definitions do |t|
          t.change :vulnerability_definition_id,    :text
          t.change :title,                          :text
          t.change :serverity,                      :text
          t.change :pci_severity_score,             :text
          t.change :pci_status,                     :text
          t.change :cvss_vector,                    :text
          t.change :cvss_access_vector_id,          :text
          t.change :cvss_access_complexity_id,      :text
          t.change :cvss_authentication_id,         :text
          t.change :cvss_confidentiality_impact_id, :text
          t.change :cvss_integrity_impact_id,       :text
          t.change :cvss_availability_impact_id,    :text
        end

        change_table :nexpose_data_vulnerability_instances do |t|
          t.change :vulnerability_id, :text
          t.change :asset_id,         :text
          t.change :scan_id,          :text
          t.change :status,           :text
          t.change :service,          :text
          t.change :protocol,         :text
        end

        change_table :nexpose_data_vulnerability_references do |t|
          t.change :vulnerability_reference_id, :text
          t.change :source,                     :text
          t.change :reference,                  :text
        end

        change_table :nexpose_result_exceptions do |t|
          t.change :nx_scope_type,    :text
          t.change :reason,           :text
          t.change :state,            :text
          t.change :nexpose_response, :text
        end

        change_table :nexpose_result_export_runs do |t|
          t.change :state, :text
        end

        change_table :nexpose_result_validations do |t|
          t.change :state,            :text
          t.change :nexpose_response, :text
        end
      end

      dir.down do
        change_table :nexpose_data_assets do |t|
          t.change :asset_id,     :string
          t.change :url,          :string
          t.change :os_name,      :string
          t.change :last_scan_id, :string
        end

        change_table :nexpose_data_exploits do |t|
          t.change :nexpose_exploit_id, :string
          t.change :skill_level,        :string
          t.change :source_key,         :string
          t.change :source,             :string
        end

        change_table :nexpose_data_import_runs do |t|
          t.change :state,        :string
          t.change :import_state, :string
        end

        change_table :nexpose_data_scan_templates do |t|
          t.change :scan_template_id, :string
          t.change :name,             :string
        end

        change_table :nexpose_data_sites do |t|
          t.change :site_id,      :string
          t.change :name,         :string
          t.change :importance,   :string
          t.change :type,         :string
          t.change :last_scan_id, :string
        end

        change_table :nexpose_data_vulnerabilities do |t|
          t.change :vulnerability_id, :string
          t.change :title,            :string
        end

        change_table :nexpose_data_vulnerability_definitions do |t|
          t.change :vulnerability_definition_id,    :string
          t.change :title,                          :string
          t.change :serverity,                      :string
          t.change :pci_severity_score,             :string
          t.change :pci_status,                     :string
          t.change :serverity,                      :string
          t.change :cvss_vector,                    :string
          t.change :cvss_access_vector_id,          :string
          t.change :cvss_access_complexity_id,      :string
          t.change :cvss_authentication_id,         :string
          t.change :cvss_confidentiality_impact_id, :string
          t.change :cvss_integrity_impact_id,       :string
          t.change :cvss_availability_impact_id,    :string
        end

        change_table :nexpose_data_vulnerability_instances do |t|
          t.change :vulnerability_id, :string
          t.change :asset_id,         :string
          t.change :scan_id,          :string
          t.change :status,           :string
          t.change :service,          :string
          t.change :protocol,         :string
        end

        change_table :nexpose_data_vulnerability_references do |t|
          t.change :vulnerability_reference_id, :string
          t.change :source,                     :string
          t.change :reference,                  :string
        end

        change_table :nexpose_result_exceptions do |t|
          t.change :nx_scope_type,    :string
          t.change :reason,           :string
          t.change :state,            :string
          t.change :nexpose_response, :string
        end

        change_table :nexpose_result_export_runs do |t|
          t.change :state, :string
        end

        change_table :nexpose_result_validations do |t|
          t.change :state,            :string
          t.change :nexpose_response, :string
        end
      end
    end
  end
end
