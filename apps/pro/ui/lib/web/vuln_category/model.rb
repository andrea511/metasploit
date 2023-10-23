# Including this module into your categorization scheme ApplicationRecord subclass under the {Web::VulnCategory}
# namespace will add validators so that the name and summary attributes follow the categorization scheme interface.
module Web::VulnCategory::Model
  extend ActiveSupport::Concern

  included do
    #
    # Validations
    #

    validates :summary, :presence => true
    validates :name,
              :format => {
                  :message => 'is not compact',
                  :with => /\A\S+\Z/
              },
              :presence => true
    validate :verbosity
  end

  #
  # Instance Methods
  #

  private

  # Validates that name is less verbose than summary
  #
  # @return [void]
  def verbosity
    if name and summary and name.length > summary.length
      errors.add(:name, 'is more verbose than summary')
    end
  end
end
