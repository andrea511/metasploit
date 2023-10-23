module Wizards
module VulnValidation
  class TaskConfig < ::TaskConfig
    attr_reader :procedure
    
    def initialize(wizard_procedure)
      super(:workspace => wizard_procedure.workspace)
      @procedure = wizard_procedure
    end

    # @return [Hash["task_id"]] the id of the Vuln Validation Commander task
    def rpc_call
      client.start_vuln_validation_wizard config_to_hash
    end

    def resume_rpc_call
      client.resume_vuln_validation_wizard config_to_hash
    end

    # @return [Hash] that is passed to the module
    def config_to_hash
      hash = {
        'DS_PROCEDURE_ID' => procedure.id,
        'DS_PROUSER' => procedure.user.username,
        'workspace' => procedure.workspace.name
      }
      if procedure.config_hash.has_key? :task_id
        hash.merge!({ 'task_id' => procedure.config_hash[:task_id] })
      end
      hash
    end

  end
end
end
