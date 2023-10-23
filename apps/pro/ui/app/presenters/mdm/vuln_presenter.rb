require 'mdm/vuln_attempt/status'

module Mdm
  class VulnPresenter
    include Mdm::VulnAttempt::Status

    def initialize(vuln)
      @vuln = vuln
    end

    def as_json(opts={})
      @vuln.as_json.merge!(
       'action' => attempt_action,
       'status' => vuln_attempt_status(@vuln.fail_reason, @vuln.exploited, @vuln.last_fail_reason),
       'status_title' => status_title
      )
    end

    def attempt_action
      #TODO: When we add the required data model to track Imports with a Vuln we determine the action type
      'Exploit'
    end

    def status_title
      fail_reason if vuln_attempt_status == Mdm::VulnAttempt::Status::FAILED
    end

  end
end
