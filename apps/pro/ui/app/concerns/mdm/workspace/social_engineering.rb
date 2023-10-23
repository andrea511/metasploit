module Mdm::Workspace::SocialEngineering
  extend ActiveSupport::Concern

  included do
    #
    # Associations
    #

    has_many :social_engineering_campaigns, :class_name => 'SocialEngineering::Campaign', :dependent => :destroy
  end
end