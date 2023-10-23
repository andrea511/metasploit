module Mdm
  class RelatedHostPresenter < DelegateClass(Host)

    include Presenters::OsIcons
    include Presenters::Host
    include Mdm::VulnAttempt::Status

    def as_json(opts={})
      super.merge!({
        icon: os_to_icon(os_name),
        status: host_status_text(self),
        vuln_attempt_status: vuln_attempt_status_agg
      })
    end


    private

    def vuln_attempt_status_agg
      vuln_attempt_status(
        vuln_attempts_fail_reason.first,
        vuln_attempts_exploited.first,
        vuln_attempts_last_fail_reason.first
      )
    end

  end
end