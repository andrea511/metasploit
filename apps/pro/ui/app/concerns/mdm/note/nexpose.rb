module Mdm::Note::Nexpose
  extend ActiveSupport::Concern

  included do
    #
    # Validations
    #

    validate :vuln_note_under_nexpose_limit

    # If this is a note on a vuln make sure it is under the nexpose comment exception limit
    #
    # @return [Boolean]
    def vuln_note_under_nexpose_limit
      if not (!data.nil? and data.is_a? Hash and data[:comment].try(:size).nil?) and not vuln_id.nil?
        errors.add(:data, 'is not under nexpose character limit') if data[:comment].size > 1024
      end
    end

  end
end
