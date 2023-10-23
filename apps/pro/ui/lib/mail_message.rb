class MailMessage
  attr_accessor :subject, :body, :from_address

  def initialize
    @recipients = []
    @attachments = [] 
  end

  def add_recipient(address)
    @recipients << address 
  end

  def to_addresses
    @recipients
  end

  def add_attachment(name, data)
    @attachments << MailAttachment.new(name, data) 
  end

  def attachments
    @attachments
  end

  private

  class MailAttachment
    attr_reader :name, :data

    def initialize(name, data)
      @name = name
      @data = data
    end
  end
end
