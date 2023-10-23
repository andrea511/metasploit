# Explicit requires for engine/prosvc.rb
#
# Gems
#
require 'action_mailer'
require 'sender'

class ActionMailerSender < Sender
  def send(message)
    Emailer.generate_email(message).deliver_now
  end

  private

  class Emailer < ActionMailer::Base
    def generate_email(message)
      message.attachments.each do |attachment|
        attachments[attachment.name] = attachment.data
      end

      mail(
        :from    => message.from_address,
        :to      => message.to_addresses,
        :subject => message.subject,
        :body    => message.body
      )  
    end
  end
end
