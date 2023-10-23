module Mdm::Vuln::Nexpose
  extend ActiveSupport::Concern

  included do
    #
    # Associations
    #

    # @!attribute [rw] nexpose_vulnerability_definition
    #   @return [::Nexpose::Data::VulnerabilityDefinition] The Nexpose representation for this vuln
    belongs_to :nexpose_vulnerability_definition, class_name: "::Nexpose::Data::VulnerabilityDefinition", foreign_key: :nexpose_data_vuln_def_id, optional: true
  end

  #
  # CONSTANTS
  #

	NEXPOSE_REF_ID_PATTERN = /^NEXPOSE-/

	def from_nexpose?
		name =~ NEXPOSE_REF_ID_PATTERN
  end

  def not_exploitable
    !self.vuln_attempts.last.try(:last_fail_reason).nil?
  end

  def markable
    !(self.nexpose_data_vuln_def_id.nil?) && self.vuln_attempts.count > 0 && !self.pushed && !self.vuln_attempts.last.try(:exploited)
  end

  def not_pushable_reason
    if self.nexpose_data_vuln_def_id.nil?
      reason = "This vulnerability was not sourced from Nexpose and so cannot be pushed to Nexpose."
    else
      if self.vuln_attempts.count < 1
        reason = "There are no attempts for this vulnerability"
      else
        unless self.vuln_attempts.last.exploited || self.vuln_attempts.last.last_fail_reason
          reason = "You can only push vulnerabilities that have status of Exploited or Not Exploitable."
        end

        if self.vuln_attempts.last.exploited
          reason = "Vuln has been exploited"
        end

        #TODO: Memoize pushed method
        pushed_timestamp = self.pushed

        if pushed_timestamp
          reason = "Already pushed to Nexpose - #{pushed_timestamp}"
        end
      end
    end

    reason
  end

  def pushable
    (self.vuln_attempts.count > 0 && !self.nexpose_data_vuln_def_id.nil? &&
      (self.vuln_attempts.last.exploited || !self.vuln_attempts.last.last_fail_reason.nil?)) && !self.pushed
  end

  def pushed
    match_result = MetasploitDataModels::AutomaticExploitation::MatchResult.joins(
      MetasploitDataModels::AutomaticExploitation::MatchResult.join_association(:match)
    ).where(
      MetasploitDataModels::AutomaticExploitation::Match[:matchable_id].eq(self.id)
    ).first

    unless match_result.nil?
      exception = Nexpose::Result::Exception.where(automatic_exploitation_match_result_id: match_result.id, sent_to_nexpose: true).first
      validation = Nexpose::Result::Validation.where(automatic_exploitation_match_result_id: match_result.id, sent_to_nexpose: true).first
    end

    timestamp = false

    unless exception.nil?
      timestamp = exception.sent_at
    end

    unless validation.nil?
      timestamp = validation.sent_at
    end

    timestamp

  end

  def latest_nexpose_result
    match_result = MetasploitDataModels::AutomaticExploitation::MatchResult.for_vuln_id(id).last
    match_result.try(:latest_nexpose_result)
  end

end
