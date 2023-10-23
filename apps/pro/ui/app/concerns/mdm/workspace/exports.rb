module Mdm::Workspace::Exports
  extend ActiveSupport::Concern

  included do
    has_many :exports, :class_name => 'Export', :dependent => :destroy
  end
end