module Apps
  class AppCategory < ApplicationRecord
    #
    # Associations
    #
    has_and_belongs_to_many :apps, :class_name => 'Apps::App'

    #
    # Validations
    #
    validates_presence_of :name

  end
end
