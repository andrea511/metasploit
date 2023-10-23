module Apps
module AppPresenters
  class CredentialIntrusion < Apps::AppPresenters::Base
    include Apps::AppPresenters::AuthPresenterMethods

    def self.row_stats
      [
        :hosts_tried,
        :sessions_opened
      ]
    end

    def self.stats
      [
        {
          :name => :hosts_tried,
          :type => :percentage,
          :num => :hosts_tried,
          :total => :hosts_selected,
          :clickable => :false
        },
        {
          :name => :sessions_opened,
          :type => :stat,
          :num => :sessions_opened,
          :clickable => :true
        }
      ]
    end


    # @param name [String] the name of the collection you want
    # @return nil if collection is empty.
    # @return [Hash] with the following keys otherwise:
    #   :collection => (the base ActiveRecord::Relation you want to display)
    #   :columns => An array of symbols containing column names in the results
    #   :searchable => used in the UI
    #   :search_columns => An array of symbols containing searchable column names
    def collection(name)
      case name.to_sym
      when :sessions_opened
        {
          :collection => app_run.tasks.first.sessions
                                .joins(:host)
                                .select('sessions.id AS session_name,
                                         hosts.name AS host_name,
                                         hosts.address AS host_address,
                                         sessions.stype AS type,
                                         sessions.opened_at AS opened_at'),
          :columns => [:session_name, :host_name, :host_address, :type, :opened_at],
          :render_row => lambda { |model|
            {
              :host_address => model.host_address.to_s
            }
          }
        }
      end
    end
  end
end
end