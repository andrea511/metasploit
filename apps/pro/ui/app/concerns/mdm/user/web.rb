module Mdm::User::Web
  extend ActiveSupport::Concern

  included do
    #
    # Associations
    #

    has_many :web_request_groups, :class_name => 'Web::RequestGroup', :dependent => :destroy
  end
end