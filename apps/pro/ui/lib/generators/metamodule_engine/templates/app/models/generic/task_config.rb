module <%= file_name.camelize %>
  class TaskConfig < Apps::TaskConfig
    # set the name of the App#symbol used with this task config
    self.app_symbol = '<%= file_name %>'

    #
    # Constants
    #

    # Available report type to render
    REPORT_TYPE = :mm_segment_fw


    #
    # Attributes
    #


    #
    # Validations
    #


    #
    # Instance methods
    #

    def initialize(args={}, report_args={})
      super
    end

    def app_run_config
      {
          'scan_task' => {

          }
      }
    end

    # todo: figure out how to hide this
    def rpc_call(client)
      client.start_<%= file_name %>_testing(config_to_hash)
    end

    private



  end
end
