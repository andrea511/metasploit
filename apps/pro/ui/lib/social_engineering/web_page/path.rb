module SocialEngineering::WebPage::Path
  extend ActiveSupport::Concern

  #
  # CONSTANTS
  #

  PATH_REGEX = /\A[^\s^?]*\z/ # disallow whitespace and ?'s

  included do
    #
    # Callbacks - in call order
    #

    before_validation :ensure_path_starts_with_slash
    before_save :ensure_path_starts_with_slash

    #
    # Validations
    #

    validates :path,
              :format => {
                  :message => 'cannot contain whitespace or question marks.',
                  :with => PATH_REGEX
              },
              :presence => true,
              :uniqueness => {
                  :message => 'must be unique to this campaign.',
                  :scope => :campaign_id
              }
    validate :path_not_reserved
  end

  #
  # Instance Methods - sorted by name
  #

  private

  def ensure_path_starts_with_slash
    self.path = "/#{self.path}" if self.path.present? && self.path.match(/^[^\/]/)
  end

  # We reserve a resource path for the email tracking functionality
  def path_not_reserved
    if path == SocialEngineering::VisitRequest::EMAIL_TRACKING_PATH
      errors.add(:path, "'#{path}' is reserved by the system")
    end
  end
end