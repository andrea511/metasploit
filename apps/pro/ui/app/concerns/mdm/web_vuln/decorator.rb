# Methods that are used in views to display {Mdm::WebVuln::Web} fields.
module Mdm::WebVuln::Decorator
  extend ActiveSupport::Concern

  #
  # CONSTANTS
  #

  # Turns Mdm::WebVuln#risk into an English name for the risk. To get the name of the risk for a Mdm::WebVuln just use
  # {#risk_label}.
  #
  # @see #risk_label
  RISK_LABELS = [
      'None',
      'Info',
      'Disclosure',
      'Low',
      'Medium',
      'High'
  ]

  #
  # Class methods
  #

  module ClassMethods
    # Turns the numeric Mdm::WebVuln#risk into a English word describing the risk.
    #
    # @return [String] {RISK_LABELS} element for the Mdm::WebVuln#risk.
    def risk_label(risk)
      numerical_risk = risk.to_i

      RISK_LABELS[numerical_risk]
    end
  end

  #
  # Instance Methods
  #
  # Renders either the #category {Web::VulnCategory::Metasploit#name name} or fallback to the #legacy_category.
  #
  # @deprecated Update your usage to use Mdm::WebVuln#legacy_category, Mdm::WebVuln#category's
  #   {Web::VulnCategory::Metasploit#name name} and Mdm::WebVuln#category's {Web::VulnCategory::Metasploit#owasps
  #   associated OWASP categories}.
  #
  # @return [String] category.{Web::VulnCategory::Metasploit#name name} if #category is not `nil`.
  # @return [String] #legacy_category if #category is `nil` and #legacy_category is not `nil`.
  # @return ['None'] if #category is `nil` and #legacy_category is `nil`.
  def category_label
    if category
      category.name
    elsif legacy_category
      legacy_category
    else
      'None'
    end
  end

  def risk_label
    self.class.risk_label(risk)
  end

  # Return string with {#category_label} and Mdm::WebVuln#id.
  #
  # @return [String] <category_label> (<id>)
  def to_s
    "#{category_label} (#{id})"
  end
end

