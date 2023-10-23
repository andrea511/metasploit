# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :apps_domino_edge, class: 'Apps::Domino::Edge' do

    # Associations
    association :dest_node, factory: :apps_domino_node
    association :login, factory: :metasploit_credential_login

    # association :run, :domino, factory: :app_run
    # association :source_node, factory: :apps_domino_node

    # Ensure the workspaces and App Run models are consistent
    # There must be a better way to do this, but I cannot figure it out
    after(:build)  do |edge|
      edge.login.core.origin = FactoryBot.build(:metasploit_credential_origin_manual)

      # make the Login of Origin Type manual
      edge.run = edge.dest_node.run
      edge.source_node = FactoryBot.build(:apps_domino_node, :no_run)
      edge.source_node.run = edge.run

      # This became a nightmare so fast.
      edge.login.core.workspace_id = edge.run.workspace_id
      edge.login.service.host.workspace_id = edge.run.workspace_id
      edge.source_node.host.workspace_id = edge.run.workspace_id
      edge.dest_node.host.workspace_id = edge.run.workspace_id
    end

  end
end
