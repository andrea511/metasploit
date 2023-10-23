# Specializes ActiveSupport::Notifications so {#instrument} can be called directly without the need to pass
# an event name.
module Metasploit::Pro::Engine::Application::Notifications
  #
  # CONSTANTS
  #

  CALLER_DESCRIPTION_REGEX = /(?<file>.*):(?<line>\d+):in `(?<method>.*)'/

  #
  # Instance Methods
  #

  def instrument(&block)
    method_name = nil

    # Find the first method not named 'instrument' in the call stack.
    # Some objects delegate the instrument method to another object which causes
    # the first method on the stack to be 'instrument'.  In these cases we don't
    # want the event name to be instrument.
    caller_descriptions = caller.to_a
    until(caller_descriptions.empty?)
      caller_description = caller_descriptions.shift
      match = CALLER_DESCRIPTION_REGEX.match(caller_description)
      if match && match[:method] != __method__.to_s
        method_name = match[:method]
        break
      end
    end

    event_name = "#{method_name}.#{notification_namespace}"
    ActiveSupport::Notifications.instrument(event_name, &block)
  end

  def notification_namespace
    @notification_namespace ||= 'metasploit-pro-engine'
  end
end