module Pro
  module DynamicStagers
    module Sanitizer
      extend ActiveSupport::Concern

      def sanitize_options_hash(opts)
        raise ArgumentError, "Invalid Argument Type: #{opts.class}" unless opts.kind_of?(Hash)
        opts.dup.delete_if { |k, v| v.nil? } # reject nil keys
      end
    end
  end
end