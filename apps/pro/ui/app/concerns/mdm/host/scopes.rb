module Mdm::Host::Scopes
  extend ActiveSupport::Concern

  included do
    scope :with_table_data, lambda {
      select([
        Mdm::Host[Arel.star],
        'array_to_json(array_agg(vuln_attempts.exploited)) as vuln_attempts_exploited',
        'array_to_json(array_agg(vuln_attempts.fail_reason)) as vuln_attempts_fail_reason',
        'array_to_json(array_agg(vuln_attempts.last_fail_reason)) as vuln_attempts_last_fail_reason',
        'count(tags.name) as tag_count'
      ])
    }

    scope :related_hosts, lambda { |ref_ids,host|
      joins(
        Mdm::Host.join_association(:vulns),
        Mdm::Host.join_association(:tags, Arel::Nodes::OuterJoin),
        Mdm::Vuln.join_association(:vuln_attempts,Arel::Nodes::OuterJoin),
        Mdm::Vuln.join_association(:vulns_refs)
      ).where(
        Mdm::VulnRef[:ref_id].in(ref_ids)
            .and(Mdm::Vuln[:host_id].not_eq(host.id))
            .and(Mdm::Host[:workspace_id].eq(host.workspace_id))
      ).group(
        [
          Mdm::Host[:id]
        ]
      )
    }
    # Finds hosts that are attached to a given workspace
    #
    # @method workspace_id(id)
    # @scope Mdm::Host
    # @param id [Integer] the workspace to look in
    # @return [ActiveRecord::Relation] scoped to the workspace
    scope :workspace_id, ->(id) {
      where('workspace_id' => id)
    }

    # inject a relationship for web_vulns
    has_many :web_vulns, :through => :services, :class_name => 'Mdm::WebVuln', inverse_of: :host
  end

end
