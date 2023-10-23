module Pro
  module DynamicStagers
    module Code
      module Loop
        extend ActiveSupport::Concern

        include Pro::DynamicStagers::Code::Operation

        ITERATION_UPPER_LIMIT = 200
        ITERATION_LOWER_LIMIT = 100

        # @return [String] A string representing the created for loop
        def generate_for_loop
          body = []
          # If we don't have at least 3 variables in scope
          # create up to 3 so we can populate our operations
          body << scope.generate_min_vars
          # Add
          counter = Var.new(scope: scope, random: true)
          # reserve the keyspace for name but don't save the var
          # that way the var won't get improperly used inside
          # the block.
          scope[counter.name] = "do not use!!"

          iterations = rand(ITERATION_UPPER_LIMIT - ITERATION_LOWER_LIMIT) + ITERATION_LOWER_LIMIT
          body << "for(#{counter.type} #{counter.name}=0; #{counter.name} < #{iterations}; #{counter.name}++){\n"
          (rand(4)+1).times do
            body << "#{generate_operation}\n"
          end
          body << "}"
          body.join("")
        end

      end
    end
  end
end
