class ::Nexpose::Result::ExceptionPresenter
  attr_reader :result_exceptions
  attr_reader :module_detail

  def initialize(opts={})
    @result_exceptions = opts[:result_exceptions]
    @module_detail = opts[:module_detail]
  end

  def as_json(opts = {})
    {
        result_exceptions: result_exceptions,
        module_detail: module_detail
    }
  end




end