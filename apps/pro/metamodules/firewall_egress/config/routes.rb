Rails.application.routes.draw do
  scope 'workspaces/:workspace_id' do
    namespace :apps do
      namespace :firewall_egress do
        resources :task_config
      end
    end
  end
end
