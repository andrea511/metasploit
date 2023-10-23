module Pro
  module BruteForce

    class AttemptQueue

      # @!attribute attempts
      #   @return [Array<BruteForce::Reuse::Attempt>] The Bruteforce Reuse Attempt objects
      attr_accessor :attempts

      # @param attributes [Hash{Symbol => String,nil}]
      def initialize(attributes={})
        attributes.each do |attribute, value|
          public_send("#{attribute}=", value)
        end
      end

      # This method yields each attempt. After it returns it destroys the attempt
      # so we can track our progress through the run.
      #
      # @yieldparam attempt [BruteForce::Reuse::Attempt] The attempt for a Bruteforce Reuse
      # @return [void]
      def each
        attempts.each do |attempt|
          yield attempt
        end
      end

      def empty?
        attempts.count <= 0
      end
    end

  end
end
