#
#
# Implements basic interface for WebPage serialized attack configuration
#
#

module SocialEngineering::WebPage::AttackType
  extend ActiveSupport::Concern

  include SocialEngineering::WebPage::AttackType::Exploit
  include SocialEngineering::WebPage::AttackType::File
  include SocialEngineering::WebPage::AttackType::Phishing

  #
  # CONSTANTS
  #

  ATTACK_TYPES = ['none', 'phishing', 'exploit', 'file', 'java_signed_applet', 'bap']

  included do
    #
    # Validations - sorted by attribute name
    #

    validates :attack_type,
              :inclusion => {
                  :in => ATTACK_TYPES
              }
  end
end
