class Apps::AppPresenters::PassiveNetwork < Apps::AppPresenters::Base
  def self.row_stats
    [
      :packets_captured,
      :hosts_found
    ]
  end

  def self.stats
    [
      {
        :name => :packets_captured,
        :type => :stat,
        :num => :packets_captured,
        :clickable => 'false'
      },
      {
        :name => :data_captured,
        :type => :stat,
        :num => :bytes_captured,
        :clickable => 'false',
        :format => 'bytes'
      },
      {
        :name => :hosts_found,
        :type => :stat,
        :num => :hosts_found,
        :clickable => 'true'
      }
    ]
  end

  def collection(name)
    case name.to_sym
    when :hosts_found
      {
        :collection => app_run.tasks.first.hosts,
        :columns => [:address, :created_at]
      }
    end
  end
end
