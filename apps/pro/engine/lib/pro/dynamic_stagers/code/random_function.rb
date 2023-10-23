module Pro
  module DynamicStagers
    module Code
      module RandomFunction
        extend ActiveSupport::Concern

        include Pro::DynamicStagers::Code::Loop
        include Pro::DynamicStagers::Code::Conditional

        MAX_ACTIONS = 1

        # @return [Array<CVar>] An array of CVars to use as arguments for the Function
        def random_arguments
          args = []
          rand(1..9).times do
            random_var = Var.new(scope: scope, random: true)
            args << random_var
            scope[random_var.name] = random_var
          end
          return args
        end

        # Returns the random type from the list of acceptable types
        # @return [String] The return type of the function
        def random_type
          Function::RETURN_TYPES[rand(Function::RETURN_TYPES.length)]
        end

        # @return [String] The randomly generated body
        def random_body
          body = ''
          rand(1..MAX_ACTIONS).times do
            body << random_action
          end
          return body
        end

        # @return [String] The action to populate the body with
        def random_action
          if scope.functions.keys.count > 0
            option_count = 4
          else
            option_count = 3
          end

          case rand(option_count)
            when 0
              generate_operation + "\n"
            when 1
              generate_for_loop + "\n"
            when 2
              generate_if_else + "\n"
            when 3
              scope.functions.values.sample.invocation + ";\n"
          end
        end

        # @return [String] a random return string suitable for the function
        def random_return
          if type == "void"
            ""
          else
            "return #{scope.vars.keys.last};\n"
          end
        end

      end
    end
  end
end