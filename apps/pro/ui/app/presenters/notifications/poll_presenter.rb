module Notifications

  #
  # PollPresenter formats the JSON response for the workspace/notifications poll request,
  # which is used to funnels realtime data back to the UI. Eventually we will get HTTP Live
  # Streaming and can abandon this polling technique.
  #
  class PollPresenter
    attr_reader :unread_message_count
    attr_reader :workspace
    attr_reader :messages

    # @param [Hash] opts the options to create a message with.
    # @option opts [Mdm::Workspace] :workspace The workspace to scope to (optional)
    # @option opts [Integer] :unread_message_count number of messages remaining (optional)
    # @option opts [ActiveRecord::Relation] :messages number of messages remaining (optional)
    def initialize(opts={})
      @workspace            = opts[:workspace]
      @unread_message_count = opts[:unread_message_count]
      @messages             =  opts[:messages]
    end

    # @return [Hash] for final JSON serialization
    def as_json
      {
        :session_count         => zero_unless_workspace { session_count },
        :task_count            => zero_unless_workspace { task_count },
        :task_chain_errors     => zero_unless_workspace { task_error_count },
        :report_count          => zero_unless_workspace { report_count },
        :unread_message_count  => unread_message_count,
        :campaign_count        => zero_unless_workspace { campaign_count },
        :messages              => messages
      }
    end

    private

    # @return [Integer] number of open sessions in the workspace
    def session_count
      @workspace.sessions.alive.count
    end

    # @return [Integer] number of running tasks in the workspace
    def task_count
      @workspace.tasks.where(
        Mdm::Task[:state].eq(Mdm::Task::States::RUNNING).or(
          Mdm::Task[:state].eq(Mdm::Task::States::PAUSED)
        )
      ).count
    end

    # @return [Integer] number of completed reports in the workspace
    def report_count
      Report.unaccessed(@workspace.id).count
    end

    # @return [Integer] number of actively running campaigns in the workspace
    def campaign_count
      @workspace.campaigns.running.size
    end

    def task_error_count
      TaskChain.interrupted.for_workspace(@workspace).count
    end

    # Yields if @workspace is present, otherwise returns 0
    # @return [Integer]
    def zero_unless_workspace(&blk)
      if @workspace.present?
        yield
      else
        0
      end
    end
  end
end
