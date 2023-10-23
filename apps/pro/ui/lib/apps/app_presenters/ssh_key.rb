class Apps::AppPresenters::SshKey < Apps::AppPresenters::Base
  include Apps::AppPresenters::AuthPresenterMethods

  # @param name [String] the name of the collection you want
  # @return nil if collection is empty.
  # @return [Hash] with the following keys otherwise:
  #   :collection => (the base ActiveRecord::Relation you want to display)
  #   :columns => An array of symbols containing column names in the results
  #   :searchable => used in the UI
  #   :search_columns => An array of symbols containing searchable column names
  def collection(name)
    case name.to_sym
    when :successful_logins
      {
        :collection => 
          Metasploit::Credential::Login.select([
            Mdm::Service[:proto].as('protocol'),
            Mdm::Service[:port].as('port'),
            Mdm::Service[:name].as('service_name'),
            Mdm::Host[:name].as('host_name'),
            Mdm::Host[:address].as('host_address'),
            Metasploit::Credential::Realm[:value].as('realm'),
            Metasploit::Credential::Public[:username].as('public'),
            Metasploit::Credential::Private[:data].as('private'),
            Metasploit::Credential::Login[:created_at].as('created_at')
          ]).joins(
            Metasploit::Credential::Login.join_association(:tasks),
            Metasploit::Credential::Login.join_association(:service),
            Mdm::Service.join_association(:host),
            Metasploit::Credential::Login.join_association(:core),
            Metasploit::Credential::Core.join_association(:realm, Arel::Nodes::OuterJoin),
            Metasploit::Credential::Core.join_association(:public, Arel::Nodes::OuterJoin),
            Metasploit::Credential::Core.join_association(:private, Arel::Nodes::OuterJoin),
          ).where(
            Metasploit::Credential::Login[:status].eq(Metasploit::Model::Login::Status::SUCCESSFUL)
          ).where(
            Mdm::Task[:app_run_id].eq(app_run.id)
        ),
        :searchable => true,
        :search_columns => [:service_name, :pass, :user, :protocol, :host_name, :host_address],
        :columns => [:host_name, :host_address, :service_name, :protocol, :port, :public, :private, :created_at],
        :render_row => lambda { |model|
          {
            :private => Metasploit::Credential::SSHKey.new(data: model.private).to_s,
            :host_address => model.host_address.to_s
          }
        }
      }
    end
  end
end
