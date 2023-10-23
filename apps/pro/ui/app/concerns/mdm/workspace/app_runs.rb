module Mdm::Workspace::AppRuns
  extend ActiveSupport::Concern

  included do
    #
    # Associations
    #

    # Destroy AppRuns when workspace is deleted
    has_many :app_runs, :class_name => 'Apps::AppRun', :dependent => :destroy
  end
end
