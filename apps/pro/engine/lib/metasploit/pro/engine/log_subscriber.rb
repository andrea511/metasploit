module Metasploit::Pro::Engine
  class LogSubscriber < ActiveSupport::LogSubscriber
    def connect_to_database(event)
      info self.class.prefix(event)
    end

    # @see https://github.com/rails/rails/blob/77516a712b5f10d14727d807697272b4607db7bc/activerecord/lib/active_record/log_subscriber.rb
    def framework(event)
      info self.class.prefix(event)
    end

    def merge_meterpreter_extensions(event)
      info self.class.prefix(event)
    end

    def load_modules(event)
      lines = [self.class.prefix(event)]
      count_by_type = event.payload[:count_by_type]

      count_by_type.each do |type, count|
        line = "  #{count} #{type} modules loaded"
        lines << line
      end

      message = lines.join("\n")

      info message
    end

    def self.prefix(event)
      "%s (%.1fms)" % [event.name, event.duration]
    end

    def start_nada_proxy(event)
      info self.class.prefix(event)
    end

    def start_rpc_engine(event)
      info self.class.prefix(event)
    end
  end
end