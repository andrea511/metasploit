module Pro
  module DynamicStagers
    module Code
      class Var
        include Pro::DynamicStagers::Sanitizer


        TYPES = %w{ int long short DWORD  }.freeze

        attr_reader :name
        attr_reader :scope
        attr_reader :type
        attr_reader :value


        # Creates a new instance of a CVar
        # @param [Hash] opts The options hash containing name,type, and value
        # @option opts [String] :name The name of the C Variable
        # @option opts [Symbol] :type The type of the variable
        # @option opts [String] :value The default value to assign to the C variable
        # @option opts [Scope] :scope The scope to use for this object
        # @option opts [Boolean] :random whether to randomize keys that were not provided
        # @raise [ArgumentError] if opts is not a Hash
        # @raise [KeyError] if you have a missing or nil key
        def initialize(opts={})
          opts = sanitize_options_hash(opts)

          @scope = opts.fetch(:scope, Scope.new({})).dup

          if opts[:random]
            opts[:value] ||= random_value
            opts[:name]  ||= scope.random_key
            opts[:type]  ||= random_type
          end

          @name  = opts.fetch(:name).to_s
          @type  = opts.fetch(:type)
          @value = opts.fetch(:value).to_s

          raise ArgumentError, "Type must be one of: #{TYPES.join(',')}" unless TYPES.include? opts[:type]
        end

        # Creates a string representing the instantiation of the variable in C
        # @return [String] The declaration line as a string.
        def declarator
          "#{type} #{name} = #{value};"
        end

        # Returns the random type from the list of acceptable types
        # @return [String] The type for the variable
        def random_type
          TYPES.sample
        end

        # Creates a random default value for the var
        # @return [String] the default value for the variable
        def random_value
          random_int = rand(65535)
          case type
            when 'DWORD'
              return sprintf('0x%04x', random_int)
            else
              return random_int.to_s
          end
        end
      end
    end
  end
end
