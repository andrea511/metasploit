module Mdm::WebVuln::Scopes
  extend ActiveSupport::Concern

  included do
    #
    # Scopes
    #

    scope :workspace_id, lambda { |wid|
      Mdm::Workspace.find(wid).web_vulns
    }

    scope :search, lambda { |query|
      formatted_query = "%#{Mdm::WebVuln.sanitize_sql_like(query)}%"
      joins(Mdm::WebVuln.join_association(:category,Arel::Nodes::OuterJoin),
            Mdm::WebVuln.join_association(:host)).
      where(
         arel_table[:name].matches(formatted_query).or(
           Web::VulnCategory::Metasploit[:name].matches(formatted_query)
         ).or(
           arel_table[:blame].matches(formatted_query)
         ).or(
           Mdm::Host.arel_table[:name].matches(formatted_query)
         )
      )
    }

    scope :web_vuln_ids_for_workspace, ->(id) {
      Mdm::Workspace.find(id).web_vulns.pluck(:id)
    }

    # inject service association
    has_one :service, through: :web_site, class_name: 'Mdm::Service', inverse_of: :web_vulns

    # inject host association
    has_one :host, through: :service, class_name: 'Mdm::Host', inverse_of: :web_vulns
    # -> { joins(:web_site => { :service => :host}) }
  end
end
