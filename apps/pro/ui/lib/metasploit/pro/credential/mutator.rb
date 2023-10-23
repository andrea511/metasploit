require 'set'

module Metasploit
  module Pro
    module Credential
      # The Credential Mutator is responsible for taking a set of Private Credentials and mutating them based on
      # a configurable ruleset, and then returning a set of all of the mutated forms of those credentials.
      class Mutator
        include Metasploit::Pro::AttrAccessor::Boolean

        LEET_RULES = [
          :a_to_at,
          :a_to_4,
          :e_to_3,
          :l_to_1,
          :o_to_0,
          :s_to_5,
          :s_to_dollar,
          :t_to_7
        ]

        # @!attribute :base_creds
        #   @return [Array<String>] the base set of credentials to mutate
        attr_accessor :base_creds

        # @!attribute :append_current_year
        #   @return [TrueClass] if this ruleset is to be used
        #   @return [FalseClass] if this ruleset is not to be used
        boolean_attr_accessor :append_current_year, default: false

        # @!attribute :append_multiple_digits
        #   @return [TrueClass] if this ruleset is to be used
        #   @return [FalseClass] if this ruleset is not to be used
        boolean_attr_accessor :append_multiple_digits, default: false

        # @!attribute :append_single_digit
        #   @return [TrueClass] if this ruleset is to be used
        #   @return [FalseClass] if this ruleset is not to be used
        boolean_attr_accessor :append_single_digit, default: false

        # @!attribute :append_special
        #   @return [TrueClass] if this ruleset is to be used
        #   @return [FalseClass] if this ruleset is not to be used
        boolean_attr_accessor :append_special , default: false

        # @!attribute :leet_speak
        #   @return [TrueClass] if this ruleset is to be used
        #   @return [FalseClass] if this ruleset is not to be used
        boolean_attr_accessor :leet_speak, default: false

        # @!attribute :prepend_current_year
        #   @return [TrueClass] if this ruleset is to be used
        #   @return [FalseClass] if this ruleset is not to be used
        boolean_attr_accessor :prepend_current_year, default: false

        # @!attribute :prepend_multiple_digits
        #   @return [TrueClass] if this ruleset is to be used
        #   @return [FalseClass] if this ruleset is not to be used
        boolean_attr_accessor :prepend_multiple_digits, default: false

        # @!attribute :prepend_single_digit
        #   @return [TrueClass] if this ruleset is to be used
        #   @return [FalseClass] if this ruleset is not to be used
        boolean_attr_accessor :prepend_single_digit, default: false

        # @!attribute :prepend_special
        #   @return [TrueClass] if this ruleset is to be used
        #   @return [FalseClass] if this ruleset is not to be used
        boolean_attr_accessor :prepend_special, default: false


        # @param attributes [Hash{Symbol => String,nil}]
        def initialize(attributes={})
          attributes.each do |attribute, value|
            public_send("#{attribute}=", value)
          end
        end

        # Returns an array containing all possible mutations
        # for the selected rules and supplied base creds.
        #
        # @return [Set<String>] the list of all derived mutations
        def mutations
          mutated_creds = Set.new
          # Start our list with the base creds
          mutated_creds += base_creds
          # Iterates through sub-arrays of rules
          ruleset.each do |rules|
            rules.sort.each do |rule|
              mutated_creds += Metasploit::Pro::Credential::MutationRules.send(rule,base_creds)
            end
          end
          mutated_creds
        end


        # This method takes an array and finds the Powerset of all the
        # elements in that array.
        #
        # @param [Array] :elements the elements to find the powerset of
        # @return [Array<Array>] the two-dimensional array representing the Powerset
        def powerset_of(elements=[])
          elements.inject([[]]) do |accumlator, element|
            powerset = []
            accumlator.each do |i|
              powerset << i
              powerset << i + [element]
            end
            powerset
          end
        end

        # This method returns an array of symbols representing all of the
        # enabled mutation rules for this mutator.
        #
        # @return [Array<Symbol>] the list of enabled rules
        def rules
          rules = []
          rules << [:append_current_year] if append_current_year?
          rules << [:append_multiple_digits] if append_multiple_digits?
          rules << [:append_single_digit] if append_single_digit?
          rules << [:append_special] if append_special?
          rules << [:prepend_current_year] if prepend_current_year
          rules << [:prepend_multiple_digits] if prepend_multiple_digits?
          rules << [:prepend_single_digit] if prepend_single_digit?
          rules << [:prepend_special] if prepend_special?
          if leet_speak?
            rules += powerset_of(LEET_RULES)
          end
          rules
        end

        # Takes the powerset of all enabled rules and rejects any
        # incompatible grouping of rules.
        #
        # @return [Array<Array<Symbol>>] the powerset of the enabled rules
        def ruleset
          ruleset = rules
          incompatible_rules.each do |incompat_pair|
            ruleset.reject! { |x| x.include? incompat_pair[0] and x.include? incompat_pair[1] }
          end
          ruleset
        end

        private

        # Returns an array of arrays containing incompatible rules.
        # In each sub-array will be two rules that are incompatible
        # with each other.
        #
        # @return [Array<Array<Symbol>] the list of incompatible rules
        def incompatible_rules
          [
            [ :a_to_at , :a_to_4 ],
            [ :s_to_5 , :s_to_dollar ]
          ]
        end

      end

    end
  end
end