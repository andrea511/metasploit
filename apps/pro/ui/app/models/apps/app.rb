#
# An App contains metadata about a Metamodule. We really need to rename this namespace.
#
class Apps::App < ApplicationRecord
  MAX_APP_RATING = 5

  #
  # Associations
  #

  # @!attribute app_runs
  #   The {Apps::AppRun} instances of this {Apps::App}
  #
  #   @return [ActiveRecord::Relation<Apps::AppRun>]
  has_many :app_runs,
    class_name: 'Apps::AppRun',
    dependent:  :destroy

  # @!attribute app_categories
  #   The {Apps::AppCategory} instances of that describe this {Apps::App}
  #
  #   @return [ActiveRecord::Relation<Apps::AppCategory>]
  has_and_belongs_to_many :app_categories,
    class_name: 'Apps::AppCategory'

  #
  # Validations
  #
  validates :symbol, :uniqueness => true
  validates :name, :presence => true
  validates :description, :presence => true
  validates :rating, :numericality => true,
                     :inclusion => { :in => 0..MAX_APP_RATING }

  def self.register_metamodule(yaml)
    registered_app = nil

    unless self.exists?(:symbol=>yaml.fetch('symbol'))

      yaml['app_categories'] = yaml.fetch('categories').map do |cat|
        Apps::AppCategory.where(name: cat).first_or_create!
      end

      yaml.delete('categories')
      registered_app = self.create!(yaml)
    else
      app = self.find_by_symbol(yaml.fetch('symbol'))
      yaml['app_categories'] = yaml.fetch('categories').map do |cat|
        Apps::AppCategory.find_by_name!(cat)
      end
      yaml.delete('categories')

      app.assign_attributes(yaml)
      if app.changed?
        app.save
      end

    end
    registered_app

  end

end
