module Apps
module AppPresenters
  class FirewallEgress < Apps::AppPresenters::Base
    def self.row_stats
      [
        :open_port_count,
        :closed_port_count
      ]
    end

    def self.stats
      [
        {
          :name => :open_ports,
          :type => :stat,
          :num => :open_port_count,
          :clickable => :true
        },
        {
          :name => :closed_ports,
          :type => :stat,
          :num => :closed_port_count,
          :clickable => :true
        },
        {
          :name => :filtered_ports,
          :type => :stat,
          :num => :filtered_port_count,
          :clickable => :true
        }
      ]
    end

    def collection(name)
      case name.to_sym
      when :closed_ports
        {
          :collection => result_ranges.where(:state => 'closed'),
          :columns => [:start_port, :end_port, :state, :created_at]
        }
      when :open_ports
        {
          :collection => result_ranges.where(:state => 'open'),
          :columns => [:start_port, :end_port, :state, :created_at]
        }
      when :filtered_ports
        {
          :collection => result_ranges.where(:state => 'filtered'),
          :columns => [:start_port, :end_port, :state, :created_at]
        }
      end
    end

    private

    def result_ranges(run=app_run)
      Apps::FirewallEgress::ResultRange.where(:task_id => run.tasks.first.id)
    end
  end
end
end