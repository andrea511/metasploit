

class Apps::AppPresenters::VulnValidation < Apps::AppPresenters::Base
  include ApplicationHelper
  include Rails.application.routes.url_helpers
  include HostsHelper
  include ActionView::Helpers::UrlHelper

  #We need to define these for the view helpers to work :-/
  def config; Rails.application.config; end
  def controller; nil; end
  def relative_url_root; nil; end

  def self.stats
    [
      {
        :name => :hosts_imported,
        :type => :percentage,
        :num => :hosts_imported,
        :total => :total_hosts,
        :hide_on_zero => 'true',
        :clickable => 'true'
      },
      {
        :name => :vulns_found,
        :type => :stat,
        :num => :vulns_found,
        :hide_on_zero => 'true',
        :clickable => 'true'
      },
      {
        :name => :exploit_matches,
        :label => "Remote Exploit Matches",
        :type => :percentage,
        :num => :exploit_matches,
        :total => :potential_exploits,
        :hide_on_zero => 'true',
        :clickable => 'true'
      },
      {
        :name => :vuln_validations,
        :type => :stat,
        :num => :vuln_validations,
        :hide_on_zero => 'true',
        :clickable => 'true'
      },
      {
        :name => :vuln_exceptions,
        :type => :stat,
        :num => :vuln_exceptions,
        :hide_on_zero => 'true',
        :clickable => 'true'
      }
    ]
  end

  # @return [Hash] of extra keys to add to the final JSON hash
  def extra_data
    workspace_id = app_run['workspace_id']
    import = Nexpose::Data::ImportRun.where(:workspace_id => workspace_id).first
    procedure = Wizards::VulnValidation::Procedure.find_by_workspace_id(workspace_id)
    run = Apps::AppRun.find(app_run['id']) # "reload" the app run
    dry_run = procedure.config_hash.has_key?(:exploit_task) and
              procedure.config_hash[:exploit_task]['DS_OnlyMatch']
    {
      import_run_id: if import.present? then import.id else nil end,
      auto_exploitation_run_id: if run.present? then run.id else nil end,
      workspace_id: workspace_id,
      dry_run: dry_run,
      match_set_id: procedure.config_hash[:match_set_id],
      procedure_state: procedure.state,
      status: app_run_status(run, procedure),
      procedure_id: procedure.id,
      datatable_columns: {
        hosts_imported: {
          status: {
            sWidth:'70px',
            sClass: "center-text",
            bSortable: false
          },
          vm: {
            sWidth: '22px',
            sClass: "center-text"
          }
        },
        vulns_found: {
          protocol: {
            sWidth: '50px'
          },
          port:{
            sWidth: '35px'
          },
          address:{
            sWidth: '80px'
          },
          service_name:{
            sWidth: '90px'
          }
        },
        exploit_matches: {
          name: {
            bSortable: false
          },
          id: {
             bVisible: false
          },
          metasploit_module: {
            bSortable: false
          },
          readiness_state: {
            sWidth: '200px',
            bSortable: false
          },
          result_code: {
            sWidth: '70px',
            bSortable: false
          },
        }
      }
    }
  end

  # do some janky swapping between AppRun and Procedure state
  # The AppRun#state is set automatically when the task is killed.
  # Procedure state is not necessarily updated.
  def app_run_status(run, procedure)
    if run.done? and not procedure.paused?
      run.state
    else
      procedure.state
    end
  end

  # Determine the status for the vuln validation run, preferring the status from the
  # state of {Wizards::VulnValidation::Procedure}, unless the run has stopped.
  #
  # @param app_run [Apps::AppRun] the run for which we are checking the status
  #
  # @return [Symbol] the current status of the app run
  def status_for_app_run(app_run)
    if Apps::AppRun::STOPPED_STATES.include?(app_run['state'].to_sym)
      state = app_run['state'].to_sym
    else
      procedure = Wizards::VulnValidation::Procedure.find_by_workspace_id(app_run['workspace_id'])
      state = procedure.state.to_sym
    end

    case state
    when :ready
      :preparing
    when :finished, :completed
      :finished
    when :error, :aborted
      :stopped
    else
      :running
    end
  end

  # @param name [String] the name of the collection you want
  # @return nil if collection is empty.
  # @return [Hash] with the following keys otherwise:
  #   :collection => (the base ActiveRecord::Relation you want to display)
  #   :columns => An array of symbols containing column names in the results
  #   :searchable => used in the UI
  #   :search_columns => An array of symbols containing searchable column names
  def collection(name)
    matches = MetasploitDataModels::AutomaticExploitation::Match.joins(:match_set).
        where(automatic_exploitation_match_sets: {workspace_id: app_run.workspace_id})
    case name.to_sym
    when :hosts_imported
      {
        :collection => app_run.workspace.hosts.select('*, virtual_host AS VM, state AS Status'),
        :columns => [:address,:name, :vm, :created_at, :status],
        :render_row => lambda { |model|
          {
            :status => host_status_html(model),
            :address => host_address_html(model),
            :vm => host_os_virtual_html(model),
          }
        }
      }
    when :vulns_found
      vulns = app_run.workspace.vulns.where('vulns.nexpose_data_vuln_def_id IS NOT NULL')
        .joins([:service, :host])
        .select('*,vulns.name AS vuln_name, hosts.address AS address, services.name AS service_name, services.proto AS protocol, services.port AS port')

      {
        :collection => vulns,
        :columns => [:vuln_name ,:address, :service_name, :port, :protocol, :created_at],
        :sort_map => {:name => 'services.name', :protocol => 'services.proto', :port => 'services.port', :address => 'hosts.address' },
        :render_row => lambda { |model|
          {
            vuln_name: model.vuln_name,
            address: model.address.to_s,
            service_name: model.service_name,
            port: model.port,
            protocol: model.protocol,
            created_at: model.created_at
          }
        }
      }
    when :exploit_matches
      {
        :collection => matches.select('*, matchable_id AS result_code'),
        :columns => [:id, :name, :metasploit_module, :result_code, :readiness_state],
        :render_row => lambda { |model|
          readiness_state = AnalyzeResultPresenter.new()
          mod_data = analyze_results(model.matchable.host)[model.module_detail.fullname]
          if mod_data
            readiness_state = mod_data
          end
          attempt_data = model.matchable.vuln_attempts.where(module: model.module_detail.fullname).order(attempted_at: :desc).first
          {
            :name => model.matchable.name,
            :metasploit_module => model.module_detail.fullname,
            :result_code => attempt_data ?
                (attempt_data.exploited ?
                  Mdm::VulnAttempt::Status::EXPLOITED : (attempt_data.fail_reason.blank? ?
                :none : attempt_data.fail_reason)
                ) : Mdm::VulnAttempt::Status::UNTRIED,
            :readiness_state => readiness_state.as_div
          }
        }
        # add analyze results to this data, possibly replace the `none` result here
        # consider how this might cache analyze results for all hosts in the run.
      }
    when :vuln_validations
      vulns = Mdm::Vuln.select(
        Mdm::Vuln[:name],
        Mdm::Vuln[:host_id],
        Mdm::Host[:name].as('host')
      ).joins(
        Mdm::Vuln.join_association(:matches),
        Mdm::Vuln.join_association(:host),
        MetasploitDataModels::AutomaticExploitation::Match.join_association(:match_set),
        MetasploitDataModels::AutomaticExploitation::Match.join_association(:match_results)
      ).where(MetasploitDataModels::AutomaticExploitation::MatchSet[:workspace_id].eq(app_run.workspace_id)
      ).where(MetasploitDataModels::AutomaticExploitation::MatchResult[:state].eq("succeeded")
      )
      {
        :collection => vulns,
        :columns => [:host, :name],
        :render_row => lambda { |model|
          {
            :host => host_address_html(model.host).gsub(/\"|\\/,'')
          }
        }
      }
    when :vuln_exceptions
      vulns = Mdm::Vuln.select(
        Mdm::Vuln[:name],
        Mdm::Vuln[:host_id],
        Mdm::Host[:name].as('host')
      ).joins(
        Mdm::Vuln.join_association(:matches),
        Mdm::Vuln.join_association(:host),
        MetasploitDataModels::AutomaticExploitation::Match.join_association(:match_set),
        MetasploitDataModels::AutomaticExploitation::Match.join_association(:match_results)
      ).where(MetasploitDataModels::AutomaticExploitation::MatchSet[:workspace_id].eq(app_run.workspace_id)
      ).where(MetasploitDataModels::AutomaticExploitation::MatchResult[:state].eq("failed")
      )
      {
        :collection => vulns,
        :columns => [:host, :name],
        :render_row => lambda { |model|
          {
            :host => host_address_html(model.host).gsub(/\"|\\/,'')
          }
        }
      }
    end
  end

  private

  def analyze_results(host)
    # any change to the workspace will invalidate the cache and require a rebuild.
    options = {}
    c = Pro::Client.get

    # config_hash = Wizards::VulnValidation::Procedure.find_by_workspace_id(app_run['workspace_id']).config_hash[:exploit_task]
    # values to use to select payloads
    # "DS_PAYLOAD_METHOD" => "auto"
    # "DS_PAYLOAD_TYPE" => "meterpreter 64-bit"
    # "DS_PAYLOAD_PORTS" => "1024-65535"
    # "DS_EVASION_LEVEL_TCP" => 0
    # "DS_EVASION_LEVEL_APP" => 0
    # compatible_payloads('reverse', ipv6)
    task = Wizards::VulnValidation::Procedure.find_by_workspace_id(app_run['workspace_id'])
    allowed_payloads = c.payloads_for_config(task.config_hash[:exploit_task])
    unless allowed_payloads.empty?
      options[:analyze_options] = {}
      options[:analyze_options][:payloads] = allowed_payloads
      options[:cache_finder] = app_run['id']
    end
    host.analyze_results(options)
  end
end
