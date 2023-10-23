require 'active_support/core_ext/string'

class EmailBuilder
  #
  # CONSTANTS
  #

  EMAIL_LIMIT = 1

  def email
    email = make_email
    validate(email)
    email
  end

  def initialize(attributes={}, campaign_id=nil, uses_wizard=false)
    @attributes = attributes
    @campaign_id = campaign_id
    set_defaults
    set_phishing_defaults if uses_wizard
  end

  private

  def add_email_limit_message(email)
    email.errors.add(:base, email_limit_message)
  end

  def email_limit_message
    "A campaign can only have #{EMAIL_LIMIT} " + "email".pluralize(EMAIL_LIMIT) + "."
  end

  def invalid_email?(email)
    validator = EmailLimitValidator.new(EMAIL_LIMIT)
    !validator.valid?(email)
  end

  def make_email
    email = SocialEngineering::Email.new @attributes
    email.campaign_id = @campaign_id
    email
  end

  def set_defaults
    @attributes[:name] ||= 'E-mail'
    @attributes[:origin_type] ||= SocialEngineering::Email::ORIGIN_TYPES.first
    @attributes[:editor_type] ||= 'rich_text'
  end

  def set_phishing_defaults
    @attributes.merge!(SocialEngineering::Email::PHISHING_DEFAULTS)
  end

  def validate(email)
    add_email_limit_message(email) if invalid_email?(email)
  end
end
