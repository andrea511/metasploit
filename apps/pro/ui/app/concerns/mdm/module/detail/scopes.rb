module Mdm::Module::Detail::Scopes
  extend ActiveSupport::Concern

  included do
    has_one :details_summary
     scope :with_table_data, lambda {
       cols = [
         module_details[:id],
         module_details[:mtype],
         module_details[:rank],
         module_details[:name],
         module_details[:name].as('description'),
         module_details[:fullname].as('module'),
         module_details[:disclosure_date],
         module_details[:description].as('info'),
         module_base_cte[:ref_count],
         details_summaries_cte[:platform_names],
         details_summaries_cte[:target_names],
         details_summaries_cte[:action_names],
         details_summaries_cte[:ref_names]]
       from(
         Arel::Nodes::As.new(
           Arel::Nodes::Grouping.new(
             select(*cols).arel
             .with(Arel::Nodes::As.new(details_summaries_cte, details_summaries_cte_definition), Arel::Nodes::As.new(module_base_cte, module_base_cte_definition_for_workspace))
               .join(details_summaries_cte).on(details_summaries_cte[:id].eq(module_details[:id]))
               .join(module_base_cte).on(module_base_cte[:id].eq(module_details[:id])).ast),
         arel_table)
       )
     }

    scope :related_modules, lambda { |vuln|
      module_type(['exploit'])
      .joins(
        Mdm::Module::Detail.join_association(:refs),
        Mdm::Module::Ref.join_association(:refs),
        Mdm::Ref.join_association(:vulns)
      ).where(
          if vuln.kind_of? ActiveRecord::Relation
            Mdm::Vuln[:id].in(vuln.pluck(:id))
          else
            Mdm::Vuln[:id].in([vuln].flatten.map(&:id))
          end
      )
    }

    scope :workspace_id, lambda { |wid|
      related_modules(Mdm::Workspace.find(wid).vulns)
    }

    scope :details_summaries_cte_definition, -> {
      module_details
        .join(module_actions, Arel::Nodes::OuterJoin).on(module_actions[:detail_id].eq(module_details[:id]))
        .join(module_targets, Arel::Nodes::OuterJoin).on(module_targets[:detail_id].eq(module_details[:id]))
        .join(module_platforms).on(module_platforms[:detail_id].eq(module_details[:id]))
        .join(module_refs).on(module_refs[:detail_id].eq(module_details[:id]))
        .project(
          module_details[:id].as('id'),
          Arel.sql('to_jsonb(array_agg(DISTINCT module_platforms.name))').as('platform_names'),
          Arel.sql('to_jsonb(array_agg(DISTINCT module_targets.name))').as('target_names'),
          Arel.sql('to_jsonb(array_agg(DISTINCT module_actions.name))').as('action_names'),
          Arel.sql('to_jsonb(array_agg(DISTINCT module_refs.name))').as('ref_names'))
        .distinct_on(module_details[:id])
        .group(module_details[:id])
    }

    scope :module_base_cte_definition_for_workspace, -> {
      module_details
        .join(module_refs).on(module_refs[:detail_id].eq(module_details[:id]))
        .join(refs).on(refs[:name].eq(module_refs[:name]))
        .join(vulns_refs).on(vulns_refs[:ref_id].eq(refs[:id]))
        .join(vulns).on(vulns[:id].eq(vulns_refs[:vuln_id]))
        .project(
          module_details[:id],
          module_refs[:name].count.as('ref_count'))
        .group(module_details[:id])
    }

    #
    # Scopes
    #

    scope :search, lambda { |query|
      formatted_query = "%#{query}%"
      where(
         arel_table[:name].matches(formatted_query).or(
             arel_table[:description].matches(formatted_query)
         )
      )
    }

    scope :module_details, -> {
      Mdm::Module::Detail.arel_table
    }

    scope :module_platforms, -> {
      Mdm::Module::Platform.arel_table
    }

    scope :module_targets, -> {
      Mdm::Module::Target.arel_table
    }

    scope :module_actions, -> {
      Mdm::Module::Action.arel_table
    }

    scope :module_refs, -> {
      Mdm::Module::Ref.arel_table
    }

    scope :automatic_exploitation_matches, -> {
      MetasploitDataModels::AutomaticExploitation::Match.arel_table
    }

    scope :refs, -> {
      Mdm::Ref.arel_table
    }

    scope :vulns_refs, -> {
      Mdm::VulnRef.arel_table
    }

    scope :vulns, -> {
      Mdm::Vuln.arel_table
    }

    scope :match_set_ids_for_workspace, ->(id) {
      Mdm::Workspace.find(id).automatic_exploitation_match_set_ids
    }

    scope :vuln_ids_for_workspace, ->(id) {
      Mdm::Workspace.find(id).vulns.pluck(:id)
    }

    scope :details_summaries_cte, -> {
      Arel::Table.new(:details_summaries)
    }

    scope :module_base_cte, -> {
      Arel::Table.new(:module_base)
    }

  end
end
