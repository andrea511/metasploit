Rails.application.routes.draw do
  scope 'workspaces/:workspace_id' do
    namespace :apps do
      namespace :domino do
        resources :task_config do
          collection do
            get 'hosts_table'
            get 'logins_table'
            get 'sessions_table'
            get 'services_subtable'
            get 'logins_subtable'
            get 'tags_subtable'
            get 'filter_values'
            get 'search_operators'
          end
        end
      end
    end
  end
end
