module Pro
  module DynamicStagers
    module Code
      module Conditional
        extend ActiveSupport::Concern

        include Pro::DynamicStagers::Code::Operation

        # @return [String] A string representing the created conditional branch
        def generate_if_else
          body = []
          # If we don't have at least two variables in scope, create more
          # Do this until we have 3 variables to compare
          body << scope.generate_min_vars

          body << "if(#{scope.vars.keys.sample} < #{scope.vars.keys.sample})\n"
          body << generate_conditional_action
          body << "else"
          body << generate_conditional_action
          body.join("").strip
        end


        # @return [String] A string representing the action for this branch
        def generate_conditional_action
          body = []
          body << "{\n"
          if scope.functions.count == 0
            body << "#{generate_operation}\n}\n"
          else
            if rand(1) == 0
              body << "#{scope.functions.values.sample.invocation};\n}\n"
            else
              body << "#{generate_operation}\n}\n"
            end
          end
          body.join("")
        end


      end
    end
  end
end