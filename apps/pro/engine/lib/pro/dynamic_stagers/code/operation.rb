module Pro
  module DynamicStagers
    module Code
      module Operation

        extend ActiveSupport::Concern

        OPERATORS = %w{ + - * & | << >> }.freeze

        # The maximum number of operators on a single line
        MAX_OPERATORS = 3

        # @return [String] A string representing the created operation
        def generate_operation
          body = []
          body << scope.generate_min_vars
          body << "#{scope.vars.keys.sample} = #{generate_expression(scope.vars.keys)};"
          body.join
        end

        # @param [Array<String>] variables An array of variable names to use in the expression
        # @return [String] A string of the C expression to use
        def generate_expression(variables)
          # Do some input validation to keep us clean
          raise ArgumentError, "Expected an Array for variables, got a #{variables.class}" unless variables.kind_of? Array
          variables.delete_if { |variable| !variable.kind_of? String}
          raise ArgumentError, "Got an empty array of variables" if variables.empty?

          ops = (0...rand(1..MAX_OPERATORS)).map do
            if rand(1).zero?
              [OPERATORS.sample, variables.sample]
            else
              [OPERATORS.sample, rand(65535)+1]
            end
          end

          [variables.sample, ops].flatten.join(" ")
        end


      end
    end
  end
end
