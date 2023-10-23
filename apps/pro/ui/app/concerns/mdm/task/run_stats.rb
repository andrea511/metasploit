module Mdm::Task::RunStats
  extend ActiveSupport::Concern

  included do
    has_many :run_stats, :class_name => 'RunStat', :dependent => :destroy
  end
end
