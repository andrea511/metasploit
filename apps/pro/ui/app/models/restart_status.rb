class RestartStatus

  attr_accessor :error, :result

  def self.get
    begin
      c = Pro::Client.get
      status = c.call("pro.restart_status", {})
      result = status["result"]
      error  = status["error"]
      error  = nil if error == ""

      RestartStatus.new(result, error)
    rescue Rex::ConnectionRefused => e
      RestartStatus.new("restarting", nil)
    end
  end

  def initialize(result, error)
    @result = result
    @error = error
  end

  def in_progress?
    complete? or restarting?
  end

  def complete?
    @result == "complete"
  end

  def restarting?
    @result == "restarting"
  end

  def error?
    @result == "error"
  end

  def restart
    c = Pro::Client.get
    r = c.call("pro.restart_service", { 'keep_files_open' => true })
    success = (r["status"] == "success")
    @result = "restarting" if success
    return success
  end

end
