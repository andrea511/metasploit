# Canonical `Mdm::VulnAttempt#status`.
#
# `Mdm::VulnAttempt#status` is restricted to values in {ALL}, so new valid values need to be added to this
# module:
#
# 1. Add a String constant where the constant name is in SCREAMING_SNAKE_CASE and the String in Title Case.  The String
#    should work in the sentences 'Login status is <status>' and 'Login is <status>'.
# 2. Add the new constant to {ALL}.
#
module Mdm::VulnAttempt::Status
  #
  # CONSTANTS
  #

  # When Presenters::Mdm::VulnAttempt#status` reports that `Mdm::VulnAttempt` gained a session.
  EXPLOITED = 'Exploited'

  # When `Presenters::Mdm::VulnAttempt#status` reports that `Mdm::VulnAttempt` has not exploited
  # and does not have a failure reason
  UNTRIED = 'Untried'

  # When `Presenters::Mdm::VulnAttempt#status` reports that `Mdm::VulnAttempt` has exploited
  # and has a failure reason
  FAILED = 'Failed'

  # When `Presenters::Mdm::VulnAttempt#status` reports that `Mdm::VulnAttempt` has a failure reason
  # of Msf::Module::Failure::NotVulnerable
  NOT_EXPLOITABLE = 'Not Exploitable'


  # All values that are valid for `Presenters::Mdm::VulnAttempt#status`.
  ALL = [
    EXPLOITED,
    UNTRIED,
    FAILED,
    NOT_EXPLOITABLE
  ]


  def vuln_attempt_status(fail_reason = nil, exploited = nil, last_fail_reason = nil)
    # If last fail reason is set, then that means we have marked the attempt as NOT_EXPLOITABLE
    unless last_fail_reason.nil?
      return Mdm::VulnAttempt::Status::NOT_EXPLOITABLE
    end

    if fail_reason == Msf::Module::Failure::NotVulnerable
      return Mdm::VulnAttempt::Status::NOT_EXPLOITABLE
    end

    if (exploited == 'f' || exploited == false) && fail_reason
      return Mdm::VulnAttempt::Status::FAILED
    end

    if (exploited == 't' || exploited == true) && !fail_reason
      return Mdm::VulnAttempt::Status::EXPLOITED
    end

    if exploited.nil? && fail_reason.nil?
      return Mdm::VulnAttempt::Status::UNTRIED
    end

  end

end
