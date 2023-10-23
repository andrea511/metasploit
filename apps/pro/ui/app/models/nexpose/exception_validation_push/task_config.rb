module Nexpose
  module ExceptionValidationPush
    class TaskConfig < ::TaskConfig

      # @param [Hash] attributes the options hash
      # @option attributes [Integer] :export_run_id the id of the ExportRun to kick off.
      def initialize(attributes)
        super
        @export_run_id = attributes[:export_run_id]
      end

      # @return [Hash["task_id"]] the id of the Quick Pentest Commander task
      def rpc_call
        client.start_nexpose_exception_and_validation_push_v2 config_to_hash
      end

      # @return [Hash] that is passed to the module
      def config_to_hash
        {
          'workspace' => workspace.name,
          'username' => username,
          'DS_EXPORT_RUN_ID' => @export_run_id
        }
      end
    end
  end
end
