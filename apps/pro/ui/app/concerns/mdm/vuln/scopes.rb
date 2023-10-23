module Mdm::Vuln::Scopes
  extend ActiveSupport::Concern

  included do
    scope :with_table_data, lambda {
      select([
               Mdm::Vuln[:id].as('vuln_id'),
               Mdm::VulnAttempt[:id].as('id'),
               Mdm::Vuln[:name],
               Mdm::Module::Detail[:name].as('description'),
               Mdm::VulnAttempt[:username].as('username'),
               Mdm::VulnAttempt[:attempted_at],
               Mdm::VulnAttempt[:exploited],
               Mdm::VulnAttempt[:fail_reason],
               Mdm::VulnAttempt[:last_fail_reason],
               Mdm::VulnAttempt[:module]
             ])
    }

    scope :event_history, lambda { |vuln|
      joins(
        Mdm::Vuln.join_association(:vuln_attempts),
        Mdm::Vuln.join_association(:refs),
        Mdm::Ref.join_association(:module_refs),
        Mdm::Module::Ref.join_association(:detail)
      ).where(
        Mdm::Vuln[:id].eq(vuln.id)
      ).group([
                Mdm::Vuln[:id],
                Mdm::VulnAttempt[:id],
                Mdm::Vuln[:name],
                Mdm::Module::Detail[:name]
              ]
      )
    }

    # Finds Vulns that are attached to a given workspace
    #
    # @method workspace_id(id)
    # @scope Mdm::Vuln
    # @param id [Integer] the workspace to look in
    # @return [ActiveRecord::Relation] scoped to the workspace
    scope :workspace_id, ->(id) {
      joins(:host).where('hosts.workspace_id' => id)
    }

    scope :from_nexpose, -> (vuln_id) {
      where(id: vuln_id, origin_type: "Nexpose::Data::ImportRun")
    }

    scope :with_nexpose_vuln_def, -> () {
      where(
        Mdm::Vuln[:nexpose_data_vuln_def_id].not_eq(nil)
      )
    }

    scope :for_module, lambda { |module_fullname|
      joins(
          :module_details
      )
      .where('module_details.fullname' => module_fullname)
    }

  end

end
