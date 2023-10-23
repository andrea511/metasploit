module Mdm::Workspace::Reports
  extend ActiveSupport::Concern

  included do
    has_many :reports, :class_name => 'Report', :dependent => :destroy
  end
end