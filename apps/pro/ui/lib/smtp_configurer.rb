require 'action_mailer'

class SmtpConfigurer
  def initialize(smtp_settings)
    @settings = smtp_settings
  end

  def load_configuration
    mailer_hash = @settings.to_mailer
    # Always set this so we don't error out on a bad SSL cert
    mailer_hash.merge!({openssl_verify_mode: 'none'})
    ActionMailer::Base.smtp_settings = mailer_hash
  end
end
