class MessageSenderFactory
  def make_email_sender
    ActionMailerSender.new
  end
end
