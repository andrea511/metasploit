module BruteforceTask::Scope
  extend ActiveSupport::Concern

  include ActiveModel::Validations

  #
  # CONSTANTS
  #

  SCOPES = ['quick', 'defaults only', 'normal', 'deep', 'known only', 'imported only', '50k']
  DEFAULT_SCOPE = 'normal'

  included do
    #
    # Validations
    #

    validates :scope,
              :inclusion => {
                  :in => SCOPES
              }
  end

  #
  # Instance Methods
  #

  def scope
    @scope ||= DEFAULT_SCOPE
  end

  def scope=(scope)
    @scope = scope || DEFAULT_SCOPE
  end
end