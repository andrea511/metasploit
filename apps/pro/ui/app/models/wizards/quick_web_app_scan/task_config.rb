module Wizards
module QuickWebAppScan
  class TaskConfig < ::TaskConfig
    attr_reader :procedure

    def initialize(wizard_procedure)
      super(:workspace => wizard_procedure.workspace)
      @procedure = wizard_procedure
    end

    # @return [Hash["task_id"]] the id of the Quick Pentest Commander task
    def rpc_call
      client.start_web_app_test config_to_hash
    end

    # @return [Hash] that is passed to the module
    def config_to_hash
      {
        'DS_PROCEDURE_ID' => procedure.id,
        'DS_PROUSER' => procedure.user.username,
        'workspace' => procedure.workspace.name
      }
    end
  end
end
end
