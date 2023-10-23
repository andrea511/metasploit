module Apps
module AppPresenters
  module AuthPresenterMethods
    module ClassMethods
      def percentage
        [:hosts_tried, :hosts_selected]
      end

      def row_stats
        [
          :services_tried,
          :successful_auths
        ]
      end

      def stats
        [
          {
            :name => :hosts_tried,
            :type => :percentage,
            :num => :hosts_tried,
            :total => :hosts_selected,
            :clickable => :false
          },
          {
            :name => :login_attempts,
            :type => :percentage,
            :num => :services_tried,
            :total => :services_selected,
            :clickable => :false
          },
          {
            :name => :successful_logins,
            :type => :stat,
            :num => :successful_auths,
            :clickable => :true
          }
        ]
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end
end
end
