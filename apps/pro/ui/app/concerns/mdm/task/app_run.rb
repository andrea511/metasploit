module Mdm::Task::AppRun
  extend ActiveSupport::Concern

  included do
    belongs_to :app_run, :class_name => 'Apps::AppRun', optional: true
  end
end
