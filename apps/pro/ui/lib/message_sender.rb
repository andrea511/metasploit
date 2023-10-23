class MessageSender 
  def initialize(sender)
    @sender = sender
  end

  def message=(message)
    @message = message
  end

  def send
    @sender.send(@message)
  end
end
