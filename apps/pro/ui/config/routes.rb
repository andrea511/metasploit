begin
  # Try Pro::Application first as it won't autoload, so if it doesn't raise a NameError, then this must be called
  # from pro/ui
  engine = Pro::Application
rescue NameError
  # Used in metasploit-pro-engine and metamodules specs
  engine = Metasploit::Pro::UI::Engine
end

#change
engine.routes.draw do
  # Admin area
  namespace :admin do |admin|
    resources :users do
      collection do
        post "delete" => "users#destroy", :as => "mass_delete"
      end
    end
  end

  # API Keys
  resources :api_keys do
    collection do
      delete "/destroy" => "api_keys#destroy", :as => "destroy"
    end

    member do
      post "/reveal" => "api_keys#reveal"
    end
  end

  resources :banner_messages
  post "/banner_messages/read" => "banner_messages#read"

  get "/campaign_files/:id" => "social_engineering/files#download"

  # Creds
  resources :creds do
    collection do
      delete :destroy_multiple
    end
  end

  # Events
  resources :events

  scope '/licenses', controller: :licenses do
    get '', action: :index,
            as: 'licenses'
    post 'register', action: :register,
                     as: 'register'
    post 'activate', action: :activate,
                     as: 'activate'
    match 'offline_activation', action: :offline_activation,
                                as: 'offline_activation',
                                via: [:get, :post]
  end

  scope "hosts/:id" do
    get "new_loot" => "loots#new", :as => "new_loot"
    match "add_loot" => "loots#add_loot", :as => "add_loot", via: [:get, :post]
    get "" => "hosts#show", :as => "host"
    patch "" => "hosts#update", :as => "update_host"
    post "" => "hosts#create_or_update_tag"
    delete "" => "hosts#remove_tag", :as => "remove_tag"
    get "edit" => "hosts#edit", :as => "edit_host"
    get "services" => "hosts#services", :as => "host_services"
    get "sessions" => "hosts#sessions", :as => "host_sessions"
    get "vulns" => "hosts#vulns", :as => "host_vulns_tab"
    get "web_vulns" => "hosts#web_vulns", :as => "host_web_vulns_tab"
    get "shares" => "hosts#shares", :as => "host_shares"
    get "loots" => "hosts#loots", :as => "host_loots"
    get "notes" => "hosts#notes", :as => "host_notes"
    get "creds" => "hosts#creds", :as => "host_creds"
    get "tags" => "hosts#tags", :as => "host_tags"
    get "attempts" => "hosts#attempts", :as => "host_attempts"
    get "details" => "hosts#details", :as => "host_details"
    get "exploits" => "hosts#exploits", :as => "host_exploits"
    get "show_alive_sessions" => "hosts#show_alive_sessions", :as => "show_alive_sessions"
    get "show_dead_sessions" => "hosts#show_dead_sessions", :as => "show_dead_sessions"
    get "show_services/json" => "hosts#show_services", dataTable:false
    get "show_services" => "hosts#show_services", :as => "show_services", dataTable:true
    get "show_history" => "hosts#show_history", :as => "show_history"
    get "show_notes" => "hosts#show_notes", :as =>"show_notes"
    patch   "update_service" => "hosts#update_service", :as => "update_service"
    delete "delete_service" => "hosts#delete_service", :as => "delete_service"
    get "show_captured_data" => "hosts#show_captured_data", :as => "show_captured_data"
    put    "update_cred" => "hosts#update_cred", :as => "update_cred"
    delete "delete_cred" => "hosts#delete_cred", :as => "delete_cred"
    post   "create_service" => "hosts#create_service", :as => "create_service"
    post   "create_cred" => "hosts#create_cred", :as => "create_cred"
    post "poll_presenter" => "hosts#poll_presenter", :as => "poll_presenter"
    get  "poll_presenter" => "hosts#poll_presenter"
  end

  # Vulns
  scope "/hosts/:host_id", :as => "host" do
    resources :vulns

    namespace :metasploit do
      namespace :credential do
        resources :cores do
          collection do
            get :accessing,   action: :index, host_origin: :accessing
            get :originating, action: :index, host_origin: :originating
          end
        end

        resources :logins do
          collection do
            get :accessing, action: :index, host_origin: :accessing
          end
        end

      end
    end
  end

  # Listeners
  resources :listeners
  scope "/listener" do
    post ":id/stop" => "listeners#stop", :as => "listener_stop"
    post ":id/start" => "listeners#start", :as => "listener_start"
    get "module_options" => "listeners#module_options", :as => "macro_module_options"
  end
  delete "listeners" => "listeners#destroy", :as => "delete_listeners"

  # Backups
  scope "/backups" do
    get "new" => "backups#new", :as => "new_backup"
    post "create" => "backups#create", :as => "create_backup"
    post "restore" => "backups#restore", :as => "restore_backup"
    get "poll" => "backups#restore_poll", :as => "restore_poll"
    get "restart" => "backups#restart", :as => "backup_restart"
    post "status" => "backups#status", :as => "backup_restart_status"
    get "download" => "backups#download", :as => "download_backup"
    get "add" => "backups#add", :as => "add_backup"
    post "upload" => "backups#upload", :as => "upload_backup"
  end
  delete "backups" => "backups#destroy", :as => "delete_backups"

  get "login" => "user_sessions#new", :as => "login"
  post "logout" => "user_sessions#destroy", :as => "logout"

  # Mdm::Loot
  get "loot/:id" => "loots#get", :as => "loot"

  # Macros
  resources :macros
  scope "/macro" do
    delete ":id/delete_action/:action_id" => "macros#delete_action", :as => "macro_delete_action"
    delete ":id/delete_action" => "macros#delete_action", :as => "macro_delete_actions"
    post ":id/add_action" => "macros#add_action", :as => "macro_add_action"
    match "module_options" => "macros#module_options", :as => "module_options", via: [:get, :post]
  end
  delete "macros" => "macros#destroy", :as => "delete_macros"

  # NeXpose Consoles
  resources :nexpose_consoles do
    collection do
      delete "/destroy" => "nexpose_consoles#destroy", :as => "destroy"
    end
  end

  # Notifications
  namespace :notifications do
    resources :messages do
      collection do
        post 'mark_read' => 'messages#mark_read', :as => 'mark_read'
        get 'poll' => 'messages#poll', :as => 'poll'
      end
    end
  end

  # Payload information
  resources :payloads do
    collection do
      get :encoders
      get :formats
    end
  end

  namespace :rest_api do
    namespace :v1 do
      get "/base/" => "base#index"

      namespace :social_engineering do
        resources :target_lists
        resources :human_targets

        resources :campaigns do
          resources :web_pages
          resources :emails
          resources :email_openings
          resources :phishing_results
          resources :visits
        end
      end
    end
    namespace :v2 do
      get "/base/" => "base#index"

      namespace :social_engineering do
        resources :target_lists
        resources :human_targets
      end

      resources :workspaces, only: [:index, :show] do
        resources :campaigns, only: [:index, :show], controller: 'social_engineering/campaigns' do
          resources :web_pages, only: [:index, :show], controller: 'social_engineering/web_pages'
          resources :emails, only: [:index, :show], controller: 'social_engineering/emails'
          resources :email_openings, only: [:index, :show], controller: 'social_engineering/email_openings'
          resources :phishing_results, only: [:index, :show], controller: 'social_engineering/phishing_results'
          resources :visits, only: [:index, :show], controller: 'social_engineering/visits'
        end
        resources :hosts, only: [:index, :show] do
          resources :sessions, only: [:index, :show]
          resources :notes, only: [:index, :show]
          resources :services, only: [:index, :show] do
            resources :vulns, only: [:index, :show]
            resources :web_sites, only: [:index, :show] do
              resources :web_forms, only: [:index, :show]
              resources :web_pages, only: [:index, :show]
              resources :web_vulns, only: [:index, :show]
            end
          end
        end
      end
    end
  end

  # Sessions
  scope "sessions/:id" do
    delete "" => "sessions#destroy", :as => "delete_session"
    match "route" => "sessions#route", :as => "session_route", via: [:get, :post]
    get "vnc" => "sessions#vnc", :as => "session_vnc"
    match "shell" => "sessions#shell", :as => "session_shell", via: [:get, :post]
    get "files" => "sessions#files", :as => "session_files"
    get "search" => "sessions#search", :as => "session_search"
    post "upload" => "sessions#upload", :as => "session_upload"
    get "download" => "sessions#download", :as => "session_download"
    get "delete" => "sessions#delete", :as => "session_delete"
  end

  # Global Settings
  scope "/settings" do
    get "" => "settings#index", :as => "settings"
    patch "update_profile" => "settings#update_profile", :as => "update_profile"
    put "update_profile" => "settings#update_profile"
  end

  # Setup & Licenses
  scope "/setup" do
    get ""           => "licenses#setup", :as => "setup"
    get "request"    => "licenses#request_key", :as => "request_key"
    get "activation" => "licenses#activation", :as => "activation"
  end

  # Mdm::Tag Search
  get "tags" => "tags#search", :as => "search_tags"

  scope 'tasks', controller: :tasks do
    post 'stop', action: :stop,
                 as: 'stop_task'
    post 'stop_all', action: :stop_all,
                     as: 'stop_all_tasks'

    post ':workspace_id/stop', action: :stop_in_workspace,
                               as: 'stop_tasks_in_workspace'
    get 'replay/:id', action: :replay,
                      as: 'replay_task'

    scope ':id' do
      get 'logs',
          as: 'task_log',
          action: :logs
      post 'pause',
           as: 'pause_task',
           action: :pause
      post 'resume',
           as: 'resume_task',
           action: :resume
      post 'stop_paused',
           as: 'stop_paused_task',
           action: :stop_paused
    end
  end

  # Updates
  scope '/updates', controller: 'updates' do
    get  '',                   action: :updates,
                               as: 'updates'
    post 'check',              action: :check
    post 'apply',              action: :apply
    post 'restart',            action: :restart
    get  'status',             action: :status
    get  'offline_apply',      action: :offline_apply
    post 'offline_apply_post', action: :offline_apply_post,
                               as: 'updates_offline_apply_post'
  end

  resources :user_sessions

  # Mdm::User settings
  resources :users

  # Wizard related reporting routes
  get '/wizard_report_tab' => 'reports#form_for_tabbed_modal', :as => 'wizard_report_tab_form'

  # Wizards
  namespace :wizards do
    namespace :quick_pentest do
      resources :form
    end
    namespace :quick_web_app_scan do
      resources :form
    end
    namespace :vuln_validation do
      resources :form do
        collection do
          get  :nexpose_sites
          get  :import_run
          post :continue_exploitation
        end
      end
    end
    namespace :payload_generator do
      resources :form do
        collection do
          get :poll
          get :download
          get :upsell
        end
      end
    end
  end

  # Workspace
  # @todo Fix mispelling of 'workspaces'
  scope 'workspace/:workspace_id' do
    delete 'events',
           to: 'events#delete_all'
    get 'tasks/update_cred_file',
        as: nil,
        to: 'tasks#update_cred_file'
  end

  #
  # Workspaces
  #

  get "/workspaces/search" => "workspaces#search"
  delete "/workspaces/destroy" => "workspaces#destroy"

  resources :workspaces do
    namespace :apps do
      resources :app_runs, as: :runs do
        member do
          put :abort
        end
      end

      resources :apps

      namespace :credential_intrusion do
        resources :task_config
      end

      # prevent the double "apps" in: /workspace/1/apps/apps/overview
      get 'overview',
          as: 'overview',
          to: 'apps#overview'

      namespace :pass_the_hash do
        resources :task_config do
          get 'show_smb_hashes', on: :collection
        end
      end

      namespace :passive_network_discovery do
        resources :task_config
      end

      namespace :single_password do
        resources :task_config do
          get 'show_creds', on: :collection
        end
      end

      namespace :ssh_key do
        resources :task_config do
          get 'show_ssh_keys', on: :collection
        end
      end
    end

    namespace :brute_force do
      scope module: 'guess' do
        resources :guess
      end

      namespace :guess do
        resources :runs, only: [:create] do
          collection do
            post :target_count
          end
        end
      end

      namespace :reuse do
        resources :groups do
          member do
            get :cores
          end
        end

        resources :targets do
          collection do
            get :filter_values
            get :search_operators
          end

          member do
            get :index
          end
        end
      end

      resources :runs
    end

    get 'credentials' => 'metasploit/credential/cores#index', :as => 'credentials'

    resources :creds, only: [:index]
    resources :custom_reports, controller: :reports

    resources :events, only: [:index]

    resources :exports do
      collection do
        delete :destroy_multiple
      end

      member do
        get 'download' => 'exports#download'
      end
    end

    namespace :fuzzing do
      resources :fuzzing do
        resources :request_groups
      end
    end

    resources :imports, only: [:new]

    resources :loots, only: [:index, :destroy] do
      collection do
        delete :destroy_multiple
      end
    end

    namespace :metasploit do
      namespace :credential do
        root to: 'cores#index'

        resources :cores do
          collection do
            delete :destroy_multiple
            get    :export
            get    :filter_values
            post   :quick_multi_tag
            get    :search_operators
          end

          member do
            put :remove_tag
            get :tags
          end

          resources :logins do
            collection do
              delete :destroy_multiple
              post :quick_multi_tag
            end

            member do
              post :get_session
              put :remove_tag
              get :tags
              post :validate_authentication
            end
          end

          resource  :origin, only: [:show]
        end

        resources :logins do
          member do
            post :attempt_session
            get  :get_session
            post :validate_authentication
          end
        end
      end
    end

    resources :module_details, only: [:show]

    namespace :nexpose do
      namespace :data do
        resources :import_runs, only: [:create,:show]

        resources :sites, only: [:index] do
          collection do
            get :filter_values
            get :search_operators
          end
        end
      end

      namespace :result do
        resources :exceptions, only: [:create,:show]
        resources :export_runs, only: [:create]

        # fixme: CHANGE TO POST TO PREVENT CSRF.
        get 'push_validations' => 'exceptions#push_validations'

        resources :validations, only: [:create,:show]
      end
    end

    note_or_service_collection_routes = ->{
      get :combined
      delete :destroy_multiple
      post :quick_multi_tag
    }

    resources :notes, only: [:create, :index] do
      collection(&note_or_service_collection_routes)
    end

    # Outside of reports to avoid dealing with report IDs unnecessarily:
    get 'report_artifact_download/(:id)', to: 'report_artifacts#download'
    get 'report_artifact_view/:id',       to: 'report_artifacts#view'

    # Resources for custom reports: logos, templates
    resources :report_custom_resources

    # Example simple template
    get 'report_template_simple_download',to: 'reports#download_simple_sample'

    # Reports and Exports
    # Standard reports
    resources :reports do
      collection do
        delete :destroy_multiple
        # Wrapper to allow all the other report partials
        # to be reloaded once type is selected:
        get :form_for_type
        post  "validate_report",
              as: "validate_report",
              action: :validate_report
      end

      member do
        get :clone
        post :format_generation_status
        post :generate_format
      end

      # Generated report files
      resources :report_artifacts, only: [:destroy, :index] do
        collection do
          post :email
        end

        member do
          get :download
          get :view
        end
      end
    end

    resources :run_stats, only: [:show]

    resources :services, only: [:index] do
      collection(&note_or_service_collection_routes)
    end

    resources :sessions, only: [:index]

    namespace :shared do
      resources :payload_settings, only: [:index, :create]
    end

    # NEW STYLE!
    # Social Engineering Campaigns
    namespace :social_engineering do
      resources :email_templates, except: [:delete]  do
        collection do
          delete "" => "email_templates#destroy", :as => "delete"
        end

        patch "edit" => "email_templates#update", on: :member
      end

      resources :files, except: [:delete]  do
        collection do
          delete "" => "files#destroy", :as => "delete"
        end
      end

      resources :human_targets, only: [:show]

      resources :target_lists, except: [:delete]  do
        collection do
          delete "" => "target_lists#destroy", :as => "delete"
        end

        get "export" => "target_lists#export"

        resources :human_targets, only: [:index] do
          collection do
            delete "" => "human_targets#destroy", :as => "delete"
          end
        end

      end

      resources :web_templates, except: [:delete] do
        collection do
          delete "" => "web_templates#destroy", :as => "delete"
          post :clone_proxy
        end
      end

      #
      # TODO ordered above, unordered below
      #

      # ------ Campaigns, components, and tracking data -----
      resources :campaigns do
        collection do
          delete "" => "campaigns#destroy", :as => "delete"
          get :logged_in
        end

        member do
          get  :check_for_configuration_errors
          post :execute
          get  :links_clicked
          get  :opened_emails
          get  :opened_sessions
          post :reset
          get  :sent_emails
          get  :submitted_forms
          get  :to_task
        end

        resource :email_server_config,
                 controller: :email_server_config,
                 only: [:edit, :update] do
          collection do
            match :check_smtp, via: [:put, :patch]
          end
        end

        resources :emails do
          collection do
            post :custom_content_preview
          end

          get :preview
          get :preview_pane
        end

        resources :phishing_results, :only => [:index, :show]

        resources :portable_files do
          member do
            get :download
          end
        end

        resources :visits

        resources :web_pages do
          collection do
            post :clone_proxy
            post :custom_content_preview
          end

          get :preview
          get :preview_pane
        end

        resource :web_server_config,
                 controller: :web_server_config,
                 only: [:edit, :update]

      end
    end

    namespace :sonar do
      resources :imports, only: [:index, :create] do
        #When we scope fdns results to an import run
        resources :fdnss, only: :index, controller: 'fdnss' do
          collection do
            get :filter_values
            get :search_operators
          end
        end
      end
    end

    delete "/tags/destroy" => "tags#destroy"

    resources :tags do
      collection do
        delete :destroy, :as => "destroy"
        get :search
      end
    end

    resources :task_chains, except: [:show] do
      collection do
        delete :destroy_multiple
        post   :resume_multiple
        post   :start_multiple
        post   :stop_multiple
        post   :suspend_multiple
        post "validate" => 'task_chains#validate', :as=>'validate'
        post "validate_schedule" => 'task_chains#validate_schedule', :as => 'validate_schedule'
      end

      member do
        get :clone
      end
    end

    resources :vulns, :only => [:index, :show] do
      collection do
        get :combined
        delete :destroy_multiple
        delete :destroy_multiple_groups
        get :push_to_nexpose_status
        get :push_to_nexpose_message
      end

      member do
        get :history
        get :related_hosts
        get :related_hosts_filter_values
        get :related_modules
        put :restore_last_vuln_attempt_status
        get :search_operators
        put :update_last_vuln_attempt_status
      end
    end

    resources :web_vulns, :only => [:index, :show] do
      collection do
        get :combined
      end

      member do
        get :search_operators
      end
    end

    resources :related_modules, :only => [:index]

    get 'vulns/:id/details',
        as: 'vuln_details',
        to: 'vulns#details'
    get 'vulns/:id/attempts',
        as: 'vuln_attempts',
        to: 'vulns#attempts'
    get 'vulns/:id/exploits',
        as: 'vuln_exploits',
        to: 'vulns#exploits'

    get 'web' => 'web#index'

    resources :web_scans, only: [:show]
  end

  # TODO: make tag creation/deletion routes make more sense
  scope "workspaces/:workspace_id" do
    #
    # Events
    #

    delete "events" => "events#delete_all", :as => 'delete_workspace_events'

    #
    # Hosts
    #

    scope 'hosts', controller: :hosts do
      get '/', action: :index,
               as: 'hosts',
               dataTable: true
      post '/', action: :create,
                as: 'create_host'

      delete '/destroy_multiple', action: :destroy_multiple,
                                  as: 'destroy_multiple_hosts'
      get '/json', action: :index,
                   as: :hosts_json,
                   dataTable: false
      get '/json_limited', action: :hosts_json_limited,
                           as: 'hosts_json_limited'
      get '/map', action: :map,
                  as: 'map_host'
      post '/multi_tag', action: :multi_tag,
                         as: 'multi_tag'
      get '/new', action: :new,
                  as: 'new_host'
      post '/quick_multi_tag', action: :quick_multi_tag,
                               as: 'quick_multi_tag'

      #
      # MUST be after any named /<name> routes so the <name> does count as an id
      #

      delete '(/:id)', action: :destroy,
                       as: 'delete_host'
      post '/:id' => 'hosts#create_or_update_tag', :as => 'create_or_update_tag'
    end

    #
    # Modules
    #

    scope 'modules', controller: :modules do
      get '/', action: :index, as: 'modules'
      post '/', action: :index
      get '/*path', action: :show, as: 'module'
    end

    #
    # RC Scripts
    #

    scope 'rc_scripts', controller: :rc_scripts do
      get '/', action: :index, as: 'rc_scripts'
      post '/', action: :index
      post '/upload', action: :upload, as: 'rc_script_upload'
      post '/*path/delete', action: :rc_script_delete, as: 'rc_script_delete'
      post '/*path/run', action: :rc_script_run, as: 'rc_script_run'
      get '/*path/show', action: :show
    end

    #
    # Sessions
    #

    get "sessions/:id" => "sessions#show", :as => "session"
    get "session_history/:id" => "sessions#history", :as => "session_history"
    match "consoles/:id" => "sessions#console_interact", :as => "session_console_interact", via: [:get, :post]
    get "console" => "sessions#console_create", :as => "session_console_create"
    get "sessions/:id/reopen" => "tasks#session_reopen", :as => "session_reopen"

    #
    # Tasks
    #

    scope 'tasks' do
      get "/:id/edit" => "tasks#edit", :as => "edit"
      get "/:id/stats/:presenter" => "tasks#stats_collection"

      get "new_import_creds" => "tasks#new_import_creds", :as => "new_import_creds"
      post "start_import_creds" => "tasks#start_import_creds", :as => "start_import_creds"

      get "update_cred_file" => "tasks#update_cred_file", :as => "update_cred_file"

      match "new_scan" => "tasks#new_scan", via: [:get, :post]
      post "start_scan" => "tasks#start_scan", :as => "start_scan"
      post  "validate_scan" => "tasks#validate_scan", :as => "validate_scan"

      match "new_import" => "tasks#new_import", :as => "new_import", via: [:get, :post]
      post "start_import" => "tasks#start_import", :as => "start_import"
      post "start_scan_and_import" => "tasks#start_scan_and_import", :as => "start_scan_and_import"
      post "validate_scan_and_import" => "tasks#validate_scan_and_import", :as => "validate_scan_and_import"
      post  "validate_import" => "tasks#validate_import", :as => "validate_import"

      match "new_exploit" => "tasks#new_exploit", :as => "new_exploit", via: [:get, :post]
      post "start_exploit" => "tasks#start_exploit", :as => "start_exploit"
      post  "validate_exploit" => "tasks#validate_exploit", :as => "validate_exploit"

      match "new_webscan" => "tasks#new_webscan", :as => "new_webscan", via: [:get, :post]
      post "start_webscan" => "tasks#start_webscan", :as => "start_webscan"
      post  "validate_webscan" => "tasks#validate_webscan", :as => "validate_webscan"

      match "new_webaudit" => "tasks#new_webaudit", :as => "new_webaudit", via: [:get, :post]
      post "start_webaudit" => "tasks#start_webaudit", :as => "start_webaudit"

      match "new_websploit" => "tasks#new_websploit", :as => "new_websploit", via: [:get, :post]
      post "start_websploit" => "tasks#start_websploit", :as => "start_websploit"

      match "new_bruteforce" => "tasks#new_bruteforce", :as => "new_bruteforce", via: [:get, :post]
      post "start_bruteforce" => "tasks#start_bruteforce", :as => "start_bruteforce"
      post  "validate_bruteforce" => "tasks#validate_bruteforce", :as => "validate_bruteforce"

      match "new_collect" => "tasks#new_collect_evidence", :as => "new_collect_evidence", via: [:get, :post]
      post "start_collect" => "tasks#start_collect_evidence", :as => "start_collect_evidence"
      post  "validate_collect_evidence" => "tasks#validate_collect_evidence", :as => "validate_collect_evidence"

      match "clone_module_run/:clone_id" => "tasks#new_module_run", :as => "clone_module_run", via: [:get, :post]
      match "new_module_run/(*path)" => "tasks#new_module_run", :as => "new_module_run", via: [:get, :post]

      post "start_module_run/*path" => "tasks#start_module_run", :as => "start_module_run"
      post "validate_module_run" => "tasks#validate_module_run", :as => "validate_module_run"

      match "clone_rc_script_run/:clone_id" => "tasks#new_rc_script_run", :as => "clone_rc_script_run", via: [:get, :post]
      match "new_rc_script_run/(*path)" => "tasks#new_rc_script_run", :as => "new_rc_script_run", via: [:get, :post]

      post "start_rc_script_run/*path" => "tasks#start_rc_script_run", :as => "start_rc_script_run"
      post "validate_rc_script_run" => "tasks#validate_rc_script_run", :as => "validate_rc_script_run"

      post "start_nexpose" => "tasks#start_nexpose", :as => "start_nexpose"
      post  "validate_nexpose" => "tasks#validate_nexpose", :as=> "validate_nexpose"

      match "new_replay" => "tasks#new_replay", :as => "new_replay", via: [:get, :post]
      post "start_replay" => "tasks#start_replay", :as => "start_replay"

      match "new_cleanup" => "tasks#new_cleanup", :as => "new_cleanup", via: [:get, :post]
      post "start_cleanup" => "tasks#start_cleanup", :as => "start_cleanup"

      post "new_upgrade_sessions" => "tasks#new_upgrade_sessions", :as => "new_upgrade_sessions"
      post "start_upgrade_sessions" => "tasks#start_upgrade_sessions", :as => "start_upgrade_sessions"

      post "start_campaign" => "tasks#start_campaign", :as => "start_campaign"

      match "new_tunnel" => "tasks#new_tunnel", :as => "new_tunnel", via: [:get, :post]
      post "start_tunnel" => "tasks#start_tunnel", :as => "start_tunnel"

      match "new_transport_change" => "tasks#new_transport_change", :as => "new_transport_change", via: [:get, :post]
      post "start_transport_change" => "tasks#start_transport_change", :as => "start_transport_change"

      post "new_nexpose_asset_group_push" => "tasks#new_nexpose_asset_group_push", :as => "new_nexpose_asset_group_push"
      post "start_nexpose_asset_group_push" => "tasks#start_nexpose_asset_group_push", :as => "start_nexpose_asset_group_push"

      match "new_nexpose_exception_push" => "tasks#new_nexpose_exception_push", :as => "new_nexpose_exception_push", via: [:get, :post]
      post "start_nexpose_exception_push" => "tasks#start_nexpose_exception_push", :as => "start_nexpose_exception_push"
      post "validate_nexpose_exception_push" => "tasks#validate_nexpose_exception_push", :as => "validate_nexpose_exception_push"

      get "" => "tasks#index", :as => "tasks"
      post "" => "tasks#index"
      get ":id" => "tasks#show", :as => "task_detail"


      get "/:id/run_stats" => "run_stats#show"
    end

    #
    # Web Applications
    #

    scope "web" do
      get "sites" => "web#index", :as => "web_sites"
      get "forms/:site_id" => "web#forms", :as => "web_forms"
      get "form/:site_id" => "web#form", :as => "web_form"
      get "vulns/:site_id" => "web#vulns", :as => "web_vulns"
      get "vuln/:vuln_id" => "web#vuln", :as => "web_vuln"

      delete "vuln/delete/:site_id" => "web#delete_vulns", :as => "delete_web_vulns"
      delete "site/delete(/:id)" => "web#delete_sites", :as => "delete_web_sites"
    end
  end

  #
  # Root
  #

  root :to => "workspaces#index"
end
