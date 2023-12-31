module Logging

  # The `Filter` class allows for filtering messages based on event
  # properties independently of the standard minimum-level restriction.
  #
  # All other Filters inherit from this class, and must override the
  # `allow` method to return the event if it should be allowed into the log.
  # Otherwise the `allow` method should return `nil`.
  class Filter

    # Creates a new level filter that will pass all log events. Create a
    # subclass and override the `allow` method to filter log events.
    def initialize
      ::Logging.init unless ::Logging.initialized?
    end

    # Returns the event if it should be forwarded to the logging appender.
    # Returns `nil` if the event should _not_ be forwarded to the logging
    # appender. Subclasses should override this method and provide their own
    # filtering semantics.
    def allow(event)
      event
    end
  end
end
