module Metasploit
  module Pro
    module Credential
      # This namepsace adds the methods that actually apply mutation rules to a given string
      module MutationRules

        # Appends the current year to the end of each string.
        #
        # @param :base_strings [Set<String>] the Set of base strings to mutate
        # @return [Set<String>] the Set of all permutations of the supplied creds
        def self.append_current_year(base_strings=[])
          run_mutations(base_strings) do |base_string|
            base_string + DateTime.now.year.to_s
          end
        end

        # Appends each digit to the end of the strings, up to length of 3 digits.
        #
        # @param :base_strings [Set<String>] the Set of base strings to mutate
        # @return [Set<String>] the Set of all permutations of the supplied creds
        def self.append_multiple_digits(base_strings=[])
          interim_creds = base_strings.dup
          3.times do
            interim_creds = append_single_digit(interim_creds)
          end
          interim_creds
        end

        # Appends each digit to the end of the strings, up to length of 1 digit.
        #
        # @param :base_strings [Set<String>] the Set of base strings to mutate
        # @return [Set<String>] the Set of all permutations of the supplied creds
        def self.append_single_digit(base_strings=[])
          run_mutations(base_strings) do |base_string|
            mutated_creds = []
            0.upto(9) do |n|
              mutated_creds << "#{base_string}#{n}"
            end
            mutated_creds
          end
        end

        # Appends each of the special chars [!#&*] to the end of the string.
        #
        # @param :base_strings [Set<String>] the Set of base strings to mutate
        # @return [Set<String>] the Set of all permutations of the supplied creds
        def self.append_special(base_strings=[])
          run_mutations(base_strings) do |base_string|
            mutated_creds = []
            mutated_creds << base_string + "!"
            mutated_creds << base_string + "#"
            mutated_creds << base_string + "&"
            mutated_creds << base_string + "*"
            mutated_creds
          end
        end

        # Replaces all instances of the letter A with the @ symbol.
        #
        # @param :base_strings [Set<String>] the Set of base strings to mutate
        # @return [Set<String>] the Set of all permutations of the supplied creds
        def self.a_to_at(base_strings=[])
          run_mutations(base_strings) do |base_string|
            base_string.gsub(/a/i, '@')
          end
        end

        # Replaces all instances of the letter A with 4.
        #
        # @param :base_strings [Set<String>] the Set of base strings to mutate
        # @return [Set<String>] the Set of all permutations of the supplied creds
        def self.a_to_4(base_strings=[])
          run_mutations(base_strings) do |base_string|
            base_string.gsub(/a/i, '4')
          end
        end

        # Replaces all instances of the letter E with 3.
        #
        # @param :base_strings [Set<String>] the Set of base strings to mutate
        # @return [Set<String>] the Set of all permutations of the supplied creds
        def self.e_to_3(base_strings=[])
          run_mutations(base_strings) do |base_string|
            base_string.gsub(/e/i, '3')
          end
        end

        # Replaces all instances of the letter L with 1.
        #
        # @param :base_strings [Set<String>] the Set of base strings to mutate
        # @return [Set<String>] the Set of all permutations of the supplied creds
        def self.l_to_1(base_strings=[])
          run_mutations(base_strings) do |base_string|
            base_string.gsub(/l/i, '1')
          end
        end

        # Replaces all instances of the letter O with 0.
        #
        # @param :base_strings [Set<String>] the Set of base strings to mutate
        # @return [Set<String>] the Set of all permutations of the supplied creds
        def self.o_to_0(base_strings=[])
          run_mutations(base_strings) do |base_string|
            base_string.gsub(/o/i, '0')
          end
        end

        # Prepends the current year to the start of each string.
        #
        # @param :base_strings [Set<String>] the Set of base strings to mutate
        # @return [Set<String>] the Set of all permutations of the supplied creds
        def self.prepend_current_year(base_strings=[])
          run_mutations(base_strings) do |base_string|
            DateTime.now.year.to_s + base_string
          end
        end

        # Appends each digit to the end of the strings, up to length of 3 digits.
        #
        # @param :base_strings [Set<String>] the Set of base strings to mutate
        # @return [Set<String>] the Set of all permutations of the supplied creds
        def self.prepend_multiple_digits(base_strings=[])
          interim_creds = base_strings.dup
          3.times do
            interim_creds = prepend_single_digit(interim_creds)
          end
          interim_creds
        end

        # Appends each digit to the end of the strings, up to length of 1 digit.
        #
        # @param :base_strings [Set<String>] the Set of base strings to mutate
        # @return [Set<String>] the Set of all permutations of the supplied creds
        def self.prepend_single_digit(base_strings=[])
          run_mutations(base_strings) do |base_string|
            mutated_creds = []
            0.upto(9) do |n|
              mutated_creds << "#{n}#{base_string}"
            end
            mutated_creds
          end
        end

        # Appends each of the special chars [!#&*] to the end of the string.
        #
        # @param :base_strings [Set<String>] the Set of base strings to mutate
        # @return [Set<String>] the Set of all permutations of the supplied creds
        def self.prepend_special(base_strings=[])
          run_mutations(base_strings) do |base_string|
            mutated_creds = []
            mutated_creds << "!" + base_string
            mutated_creds << "#" + base_string
            mutated_creds << "&" + base_string
            mutated_creds << "*" + base_string
            mutated_creds
          end
        end


        # Replaces all instances of the letter S with 5.
        #
        # @param :base_strings [Set<String>] the Set of base strings to mutate
        # @return [Set<String>] the Set of all permutations of the supplied creds
        def self.s_to_5(base_strings=[])
          run_mutations(base_strings) do |base_string|
            base_string.gsub(/s/i, '5')
          end
        end

        # Replaces all instances of the letter S with $.
        #
        # @param :base_strings [Set<String>] the Set of base strings to mutate
        # @return [Set<String>] the Set of all permutations of the supplied creds
        def self.s_to_dollar(base_strings=[])
          run_mutations(base_strings) do |base_string|
            base_string.gsub(/s/i, '$')
          end
        end

        # Replaces all instances of the letter T with 7.
        #
        # @param :base_strings [Set<String>] the Set of base strings to mutate
        # @return [Set<String>] the Set of all permutations of the supplied creds
        def self.t_to_7(base_strings=[])
          run_mutations(base_strings) do |base_string|
            base_string.gsub(/t/i, '7')
          end
        end

        private

        # Takes the Set of base strings, then yields each one to
        # a block to be mutated, sticks the results in an Set, and
        # scrubs duplicate entries before returning the Set.
        #
        # @param :base_strings [Set<String>] the Set of base strings to mutate
        # @yieldparam :base_string [String] an individual base string to be mutated
        # @yieldreturn [String] the mutated form of the string
        # @return [Set<String>] the Set of all permutations of the supplied creds
        def self.run_mutations(base_strings=[])
          results = base_strings.dup
          base_strings.each do |base_string|
            block_return = yield(base_string)
            if block_return.kind_of? Array
              results += block_return
            else
              results << block_return
            end
          end
          results
        end

      end
    end
  end
end
