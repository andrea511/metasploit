# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do

  factory :apps_domino_node, class: 'Apps::Domino::Node' do

    # Associations
    association :run, :domino, factory: :app_run
    association :host, factory: :mdm_host

    depth { rand(10) }

    trait :no_run do
      run { nil }
    end

    # Ensure the workspaces are consistent
    # There must be a better way to do this, but I cannot figure it out
    after(:build)  { |node|
      if node.run.present?
        node.host.workspace_id = node.run.workspace_id
      end
    }

  end
end
