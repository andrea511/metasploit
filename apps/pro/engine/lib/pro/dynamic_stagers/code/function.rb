module Pro
  module DynamicStagers
    module Code
      class Function
        include Pro::DynamicStagers::Code::RandomFunction
        include Pro::DynamicStagers::Sanitizer

        # An array of acceptable return types. This is a superset of Var::TYPES
        # @see CVar::TYPES
        RETURN_TYPES = (Var::TYPES + ['void']).freeze

        # @!attribute [r] arguments
        #   @return [Array<Var>]
        attr_reader :arguments

        # @!attribute [r] body
        #   @return [String] C code
        attr_reader :body

        # @!attribute [r] name
        #   @return [String] the name of the function
        attr_reader :name

        # @!attribute [r] scope
        #   @return [Scope] the scope of the function
        attr_reader :scope

        # @!attribute [r] type
        #   @return [String] the return type of the function
        attr_reader :type



        # @param [Hash] opts the options hash
        # @option opts [Array<CVar>] :arguments
        # @option opts [String] :body
        # @option opts [String] :name
        # @option opts [String] :type the return type
        # @option opts [Boolean] :random whether to randomize keys that were not provided
        # @option opts [Scope] :scope The scope to use for this object
        # @raise [ArgumentError] if opts is not a Hash
        # @raise [KeyError] if you have a missing, nil, or invalid option
        def initialize(opts={})
          opts = sanitize_options_hash(opts)

          @scope = opts.fetch(:scope, Scope.new({})).dup

          if opts[:random]
            opts[:arguments] ||= random_arguments
            opts[:body]      ||= random_body
            opts[:name]      ||= scope.random_key
            opts[:type]      ||= random_type
          end

          @arguments = opts.fetch(:arguments)
          @body      = opts.fetch(:body)
          @name      = opts.fetch(:name)
          @type      = opts.fetch(:type)

          raise KeyError, ":arguments must be an Array" unless @arguments.kind_of?(Array)

          unless RETURN_TYPES.include? opts[:type]
            raise KeyError, "Type must be one of: #{RETURN_TYPES.join(', ')}"
          end

          # Add our arguments to our local scope
          arguments.each do |arg|
            scope[arg.name] = arg
          end
        end

        # @return [String] function definition
        def definition
          "#{prototype.gsub(/;$/, '')} {\n\t#{body}\n#{random_return}}"
        end

        # @return [String] function prototype
        def prototype
          "#{type} #{name}(#{argument_definitions});"
        end

        # @return [String] C code that calls this function with the desired params
        def invocation
          "#{name}(#{serialize_arg_values})"
        end

        def inspect
          prototype
        end

        private

        # @return [String] C code to
        def argument_definitions
          arguments.map { |cvar| "#{cvar.type} #{cvar.name}" }.join(', ')
        end

        def serialize_arg_values
          arguments.map(&:value).join(', ')
        end
      end
    end
  end
end
