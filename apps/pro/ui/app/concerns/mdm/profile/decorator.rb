module Mdm::Profile::Decorator
  extend ActiveSupport::Concern

  included do
    before_create :apply_default_settings!
  end

  #
  # CONSTANTS
  #

  HTTP_PROXY_SETTINGS = :http_proxy_host, :http_proxy_port, :http_proxy_user, :http_proxy_pass
  PASSWORD_SETTINGS = ['http_proxy_pass', 'smtp_password']

  DEFAULT_SETTINGS = {
    'enable_news_feed' => true,
    'automatically_check_updates' => true,
    'usage_metrics_user_data' => true
  }

  def settings_list
    [
      {
        :category => 'Payloads',
        :default => false,
        :desc => 'Allow HTTPS-based payloads whenever possible (less reliable, but more stealthy)',
        :name => 'payload_prefer_https',
        :type => :boolean
      },
      {
        :category => 'Payloads',
        :default => false,
        :desc => 'Allow HTTP-based payloads whenever possible (mostly reliable, traverses proxies)',
        :name => 'payload_prefer_http',
        :type => :boolean
      },
      {
        :category => 'Debugging',
        :default => false,
        :desc => 'Allow access to the unsupported diagnostic console through the web browser (less secure). '+
                 'Press ctrl-tilde (~) to bring it up inside a project.',
        :name => 'allow_console_access',
        :type => :boolean
      },
      {
        :category => 'Updates',
        :default => true,
        :desc => 'Automatically check for available updates',
        :name => 'automatically_check_updates',
        :type => :boolean
      },
      {
        :category => 'Updates',
        :default => false,
        :desc => 'Connect to the Internet via http proxy to check for software updates',
        :name => 'use_http_proxy',
        :type => :boolean
      },
      {
        :category => 'News Feed',
        :default => true,
        :desc => 'Automatically update the news feed',
        :name => 'enable_news_feed',
        :type => :boolean
      },
      {
        :category => 'Usage Metrics',
        :default => true,
        :desc => "Provide anonymous usage data to Rapid7",
        :name => 'usage_metrics_user_data',
        :type => :boolean
      }
    ]
  end

  def update_proxy_error?
    settings['update_proxy_error']
  end

  private

  # Applies any of DEFAULT_SETTINGS that were unspecified by the user
  def apply_default_settings!
    self.settings.merge!(DEFAULT_SETTINGS.reject { |k,v| settings.has_key?(k) })
  end

  def usage_metrics_days_to_string
    days = UsageMetric.days_until_collection
    if days >= 0
      ". Collection starts on #{UsageMetric.collection_date.strftime("%m/%d/%Y")}."
    else
      ""
    end
  end
end
