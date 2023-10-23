module SocialEngineering::WebPage::OriginType
  extend ActiveSupport::Concern

  #
  # CONSTANTS
  #

  ORIGIN_TYPES = ['custom', 'template', 'clone']

  included do
    #
    # Callbacks - in call order
    #

    before_save :autoset_origin_type

    #
    # Validations
    #

    validates :origin_type,
              :inclusion => {
                  :in => ORIGIN_TYPES
              }
  end

  #
  # Instance Methods
  #

  private

  def autoset_origin_type
    self.origin_type = if template.present? then 'template' else 'custom' end
  end
end