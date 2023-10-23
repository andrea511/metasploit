require 'apps/app_presenters/base'

module Apps
  module AppPresenters
    class <%= file_name.camelize %> < Apps::AppPresenters::Base
      #Dummy Rows Stats for App Run on AppRun Page
      def self.row_stats
        [
            :open_port_count,
            :closed_port_count
        ]
      end

      #Dummy Tabs for Roll Up Modal
      def self.stats
        [
            {
                :name => :completed_reports,
                :type => :stat,
                :num => :open_port_count,
                :clickable => :true
            },
            {
                :name => :started_reports,
                :type => :stat,
                :num => :closed_port_count,
                :clickable => :true
            }
        ]
      end

      #Dummy Stats for Roll Up Modal Tabs
      def collection(name)
        case name.to_sym
          when :completed_reports
            {
                :collection => Apps::AppRun.where(:state=>'completed') ,
                :columns => [:state, :created_at]
            }
          when :started_reports
            {
                :collection => Apps::AppRun.where(:state=>'started') ,
                :columns => [:state, :created_at]
            }
        end
      end


    end
  end
end