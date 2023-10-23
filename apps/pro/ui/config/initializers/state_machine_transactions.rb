#
# HACK: Monkey patch to fix state_machine 1.2.0 bug https://github.com/pluginaweek/state_machine/issues/264
# use_transactions: false does not work on activerecord

module StateMachine
  module Integrations
    module ActiveRecord
      # Runs state events around the machine's :save action
      def around_save(object)
        within_transaction(object) do
          object.class.state_machines.transitions(object, action).perform { yield }
        end
      end
    end
  end
end
