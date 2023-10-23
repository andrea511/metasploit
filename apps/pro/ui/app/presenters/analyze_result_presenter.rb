class AnalyzeResultPresenter

  include ActionView::Helpers::TagHelper

  STATE_FOR_DISPLAY = {
    'READY_FOR_TEST'          => 'Ready for Test',
    "REQUIRES_CRED"           => 'Requires Credentials',
    "REUSE_PREVIOUS_OPTIONS"  => 'Reuse Previous Options',
    "MISSING_REQUIRED_OPTION" => 'Missing Required Options',
    "MISSING_PAYLOAD"         => 'Missing Compatible Payload',
    "REQUIRES_SESSION"        => 'Requires Session',
    "NEEDS_TARGET_ACTION"     => 'Needs target action',
    "INVALID_OPTION"          => 'Invalid Options',
    "NOT_APPLICABLE"          => 'Module is not applicable',
    "NOT_EVALUATED"           => 'Module not evaluated' # Consider this may make sense as 'Has matching reference', auxiliary modules are not currently evaluated.
  }

  def initialize(result = {})
    @result_hash = result
  end

  def as_div
    status_class = state == 'READY_FOR_TEST' ? "module_status_ready" : "module_status_require"
    content_tag(:div, STATE_FOR_DISPLAY[state].capitalize, :class => status_class).html_safe
  end

  def state
    @result_hash['state'] ? @result_hash['state'] : "NOT_EVALUATED"
  end

  def description
    @result_hash['description'] ? @result_hash['description'] : STATE_FOR_DISPLAY["NOT_EVALUATED"]
  end

end
