module Metasploit::Credential::Core::DataTableQueries
  extend ActiveSupport::Concern
  
  included do
    
    scope :data_tables, lambda {
      data_table_select.data_table_joins
    }
    
    scope :data_table_select, lambda {
      select([
        Metasploit::Credential::Core[:id],
        Metasploit::Credential::Realm[:value].as('domain'),
        Metasploit::Credential::Public[:username].as('username'),
        Metasploit::Credential::Private[:data].as('password'),
        Metasploit::Credential::Core[:created_at]
      ])
    }
    scope :data_table_joins, lambda {
      joins(
        Metasploit::Credential::Core.join_association(:realm, Arel::Nodes::OuterJoin),
        Metasploit::Credential::Core.join_association(:public, Arel::Nodes::OuterJoin),
        Metasploit::Credential::Core.join_association(:private, Arel::Nodes::OuterJoin),
      )
    }
    
  end
  
end