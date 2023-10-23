module Mdm::Profile::Smtp
  extend ActiveSupport::Concern

  module ClassMethods
    def load_latest_smtp_configuration
      profile = self.last
      return false if profile.nil?
      profile.load_smtp_configuration
    end
  end

  def load_smtp_configuration
    configurer = SmtpConfigurer.new(smtp_settings)
    loaded_configs = configurer.load_configuration
    logger.info "System wide SMTP configuration was set with #{loaded_configs}"
  end

  def smtp_settings
    SmtpSettings.new(settings)
  end
end