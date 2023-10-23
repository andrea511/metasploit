module Pro
  module DynamicStagers
    module Code
      class Scope < Hash
        include Pro::DynamicStagers::Sanitizer

        # The minimum number of variables we want available after
        # calling generate_min_vars without an argument
        DEFAULT_MIN_VARS = 3

        # @param [Hash] values A hash of values to use by default
        def initialize(values={})
          values = sanitize_options_hash(values)
          self.merge!(values)
        end

        # @return [Hash<String,Var>] A hash of all the Variables in this scope
        def vars
          self.select { |k,v| v.kind_of? Var}
        end

        # @return [Hash<String,Function>] A hash of all the Function in this scope
        def functions
          self.select { |k,v| v.kind_of? Function}
        end

        def random_key
          tmp_name = ::Rex::Text.rand_text_alpha(8)
          while self.has_key?(tmp_name) do
            tmp_name = ::Rex::Text.rand_text_alpha(8)
          end
          tmp_name
        end

        # Checks that there are at least `min_vars` variables available in scope.
        # If there are less than `min_vars`, we randomly generate vars until we have enough
        # @param [Integer] min_vars
        # @return [String] C code that declares new vars if necessary
        def generate_min_vars(min_vars=DEFAULT_MIN_VARS)
          declarators = ((vars.count)...(min_vars)).map do
            new_var = Var.new(scope: self, random: true)
            self[new_var.name] = new_var
            new_var.declarator + "\n"
          end
          declarators.join(' ')
        end
      end
    end
  end
end
