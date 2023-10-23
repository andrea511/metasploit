require 'ostruct'

class Wizards::VulnValidation::Procedure < Wizards::BaseProcedure
  include Metasploit::Pro::AutomaticExploitation::BuildMatches

  # @attr [OpenStruct] run_stats key/value store for relevant RunStats
  attr_reader :run_stats

  # @attr [::Nexpose::Data::ImportRun] import_run
  attr_reader :import_run

  attr_accessor :transitions_completed
  attr_accessor :max_total_transitions

  #
  # State Machine
  #
  # actual logic of the wizard lives here

  before_save :save_custom_tag

  state_machine :state, initial: :ready, use_transactions: false do
    # build a map of state -> state for the next! event
    event :next do
      transition ready: :scanning, if: :assets_from_scan?
      transition ready: :importing, if: :assets_from_import?
      transition scanning: :finished, if: :no_hosts_imported?
      transition scanning: :building_matches
      transition importing: :finished, if: :no_hosts_imported?
      transition importing: :building_matches
      transition building_matches: :dry_run, if: :dry_run?
      transition building_matches: :reporting, if: :no_vulns_found?
      transition building_matches: :exploiting
      transition dry_run: :paused
      transition exploiting: :collecting_evidence, if: :should_collect_evidence?
      transition [:exploiting, :collecting_evidence] => :cleaning_up, :if => :should_cleanup?
      transition [:exploiting, :collecting_evidence, :cleaning_up] => :reporting, :if => :should_report?
      transition [:exploiting, :collecting_evidence, :cleaning_up] => :finished
      transition reporting: :finished
    end

    # Procedure is "paused" while user verifies he wants to validate the listed vulns
    event :continue do
      transition paused: :exploiting
    end

    event :error_occurred do |error_str|
      transition any => :error
    end


    before_transition :ready => any do
      @transitions_completed = 0
    end

    before_transition :dry_run => :paused do |procedure|
      procedure.commander.module_store[:task].requested_task_action = "pause"
    end

    # No matter what state Procedure starts from, RunStats get initialized & memoized
    before_transition any => any do |procedure, transition|
      procedure.initialize_run_stats
      set_max_transitions(procedure, transition.to.to_sym)
      # print your status!
      if procedure.commander.present?
        unless transition.to == "finished"
          set_task_progress(procedure.commander.module_store, transition.to.to_sym)
          procedure.commander.print_good("Workspace:#{procedure.commander.datastore['WORKSPACE']} #{procedure.commander.module_store[:task].info}... - Progress: #{procedure.commander.module_store[:task].progress}%")
        else
          procedure.commander.module_store[:task].info = "Vulnerability Validation Complete"
        end
      end
    end

    #
    # "Bail" transitions
    #

    before_transition :ready => :importing do |procedure|
      procedure.import_run.choose_sites(procedure.config_hash[:nexpose_sites])
      procedure.save_host_count if procedure.run_stats.total_hosts.data.zero?
    end

    # Scanning did not return any results. Print an error and finish!
    before_transition :scanning => :finished do |procedure|
      procedure.commander.print_error "Scan did not find any hosts. Ending Vuln Validation run."
    end

    # Scanning did not return any results. Print an error and finish!
    before_transition :importing => :finished do |procedure|
      procedure.commander.print_error "Import did not find any hosts. Ending Vuln Validation run."
    end

    state :ready do
      def run
        #NO-OP
      end
    end

    # run the scan task
    state :scanning do
      def run
        commander.run_module(
          'auxiliary/pro/nexpose/scan_and_import',
          config_hash[:nexpose_scan_task].merge(
            'SCAN' => true,
            'IMPORT_RUN_ID' => import_run.id,
            'AUTOTAG_OS' => config_hash[:tag_by_os],
            'AUTOTAG_TAGS' => custom_tag_names,
            'BUILD_MATCHES' => false
          )
        )
        # now ensure that the vulns count matches up :)
        run_stats.vulns_found.update(:data => workspace.vulns.count)
      end
    end

    # Import straight from a console
    state :importing do
      def run
        total_hosts = run_stats.total_hosts
        total_hosts.data = import_run.sites.map { |site| site.summary['assets_count'] }.reduce(:+)
        commander.run_module(
          'auxiliary/pro/nexpose/scan_and_import', {
            'IMPORT_RUN_ID' => import_run.id,
            'AUTOTAG_OS' => config_hash[:tag_by_os],
            'AUTOTAG_TAGS' => custom_tag_names,
            'BUILD_MATCHES' => false
          }
        )
        # now ensure that the vulns count matches up :)
        run_stats.vulns_found.update(:data => workspace.vulns.count)
      end
    end

    # build an AutoExploitation::MatchSet for running the validation_commander.rb task on
    state :building_matches do
      def run

        min_rank  = config_hash[:exploit_task]['DS_MinimumRank']

        match_set = build_matches({
                       workspace: workspace,
                       blacklist: config_hash[:exploit_task]['DS_BLACKLIST_HOSTS'],
                       user: user,
                       run_stats: run_stats,
                       MINIMUM_MODULE_RANK: min_rank
                      })

        config_hash[:match_set_id] = match_set.id
        save
      end
    end

    # Needs to print the list of exploits in the log
    state :dry_run do
      def run
        match_set = MetasploitDataModels::AutomaticExploitation::MatchSet.find(config_hash[:match_set_id])
        exploitation_options = config_hash[:exploit_task].merge({
          'WORKSPACE_ID' => workspace.id,
          'MATCH_SET_ID' => match_set.id,
          'USER_ID' => user.id
        })
        # print the log
        commander.run_module 'auxiliary/pro/nexpose/validation_commander', exploitation_options
      end
    end

    # Run the validation_commander.rb module to exploit stuff (or noop in dry-run)
    state :exploiting do
      def run
        # if we've reached this point in a dry_run, then the user has clicked Continue.
        match_set = MetasploitDataModels::AutomaticExploitation::MatchSet.find(config_hash[:match_set_id])
        exploitation_options = config_hash[:exploit_task].merge({
          'WORKSPACE_ID' => workspace.id,
          'MATCH_SET_ID' => match_set.id,
          'USER_ID' => user.id,
          'DS_OnlyMatch' => false
        })
        # break and smash things
        commander.run_module 'auxiliary/pro/nexpose/validation_commander', exploitation_options
      end
    end

    state :collecting_evidence do
      def run
        # put the pieces together with our bleeding fingers
        filter_sessions_in_config(config_hash[:collect_evidence_task])
        commander.run_module 'auxiliary/pro/collect', config_hash[:collect_evidence_task]
      end
    end

    state :cleaning_up do
      def run
        # wrap those fingers up champ
        commander.run_module 'auxiliary/pro/cleanup', config_hash[:cleanup_task]
      end
    end

    state :reporting do
      def run
        report = Report.find(config_hash[:report_id])
        report.generate_delayed
      end
    end

    # State Machine helper functions

    # Sets the overall progress of the Vuln Validation Task
    def set_task_progress(procedure_commander_ms, transition)
      @transitions_completed += 1 unless transition == :error or transition == :paused
      transition_info = transition.to_s.humanize.capitalize

      transition_info = ("Exploits listed - Awaiting user interaction") if transition == :paused

      procedure_commander_ms[:task].progress = (((@transitions_completed - 1) / @max_total_transitions.to_f) * 100).to_i
      procedure_commander_ms[:task].info = transition_info
    end

    # Sets the max possible total transitions considering configuration values
    # Need to check each step because of how should_cleanup? and should_report?
    # are checked
    def set_max_transitions(procedure, transition)
      @max_total_transitions = 3
      @max_total_transitions += 1 if procedure.dry_run?
      @max_total_transitions += 1 if procedure.should_collect_evidence?
      @max_total_transitions += 1 if procedure.should_cleanup?
      @max_total_transitions += 1 if procedure.should_report?

      case transition
      when :reporting
        @max_total_transitions = @transitions_completed + 1
      when :finished
        @max_total_transitions = @transitions_completed
      end
    end
  end

  # Steps through the BaseProcedure's entire state
  #   machine, taking transitions based on user-defined options,
  #   which causes subtasks to execute in a specific sequence.
  #
  # @param comm [Class<Msf::Module>] commander module
  def execute_with_commander(comm)
    self.commander = comm
    continue! if paused?

    while can_next?
      begin
        reload # (ugh)
        run
      rescue NoMethodError
      end
      next!
    end
  end

  # @return [Boolean] if user wants to print match set, but not actually exploit
  def dry_run?
    config_hash[:exploit_task]['DS_OnlyMatch'] == true
  end

  def save_host_count
    total_hosts = run_stats.total_hosts
    total_hosts.data = import_run.sites.map { |site| site.summary['assets_count'] }.reduce(:+)
    total_hosts.save
  end

  # Returns true if the assets to be acted on in the procedure
  # are to come from a Nexpose scan of a live network.
  # @return [Boolean]
  def assets_from_scan?
    config_hash[:nexpose_gather_type].to_s.to_sym == :scan
  end

  # Returns true if the assets to be acted on in the procedure
  # come from a Nexpose import
  # @return [Boolean]
  def assets_from_import?
    config_hash[:nexpose_gather_type].to_s.to_sym == :import
  end

  # @return [Array<String>] of tag names to add to all hosts
  def custom_tag_names
    if config_hash[:use_custom_tag] and config_hash[:tagging_enabled]
      tag = Mdm::Tag.find_by_id(config_hash[:custom_tag])
      if tag.present? then tag.name else '' end
    else
      ''
    end
  end

  # @return [Mdm::Task] the attached task
  def mdm_task
    @mdm_task ||= Mdm::Task.find(self.commander[:task].task_id)
  end

  # Returns true if the system should run the collect evidence module,
  # which will run multiple scripts to gather passwords, screenshots,
  # dump hashes, etc on compromised systems, via combination of Meterpreter-based scripts
  # and auxiliary modules.
  # @return [Boolean]
  def should_collect_evidence?
    config_hash[:collect_evidence]
  end

  # Helper for state_machine transition conditions
  # @return [Boolean] whether we should generate a report
  def should_report?
    # TODO This needs a better check than just hosts, should use report
    # validations:
    config_hash[:report_enabled] and workspace.hosts.reload.exists?
  end

  # Helper for state_machine transition condition
  # Checks for a user selected cleanup task and
  # whether there are active sessions in the workspace
  # @return [Boolean] whether we should run cleanup
  def should_cleanup?
    config_hash[:cleanup_enabled] and workspace.sessions.alive.exists?
  end

  # Ran in a before_save callback
  # Saves the Mdm::Tag object on form.custom_tag, if applicable
  def save_custom_tag
    if config_hash[:custom_tag].present? and config_hash[:use_custom_tag]
      config_hash[:custom_tag].save if config_hash[:custom_tag].new_record?
    end
  end

  # TODO This method could use some explanation.
  # @return [::Nexpose::Data::ImportRun] the ImportRun to use
  def import_run
    vv_specific_attrs = Nexpose::ScanAndImport::TaskConfig::SPECIAL_NX_IMPORT_ATTRS
    @import_run ||= if assets_from_scan?
      console_id = config_hash[:nexpose_scan_task]['DS_NEXPOSE_CID'].to_i
      new_import_run = ::Nexpose::Data::ImportRun.create(
        vv_specific_attrs.merge({
              console: Mdm::NexposeConsole.find(console_id),
            workspace: workspace,
                 user: user
        })
      )
      new_import_run
    else
      attrs = vv_specific_attrs.dup
      # user already kicked off an ImportRun to load sites
      new_import_run = ::Nexpose::Data::ImportRun.find(config_hash[:import_run_id].to_i)
      if new_import_run.workspace.blank?
        attrs.merge!(workspace:workspace)
      end
      new_import_run.update(attrs)
      new_import_run
    end
  end

  def no_hosts_imported?
    workspace.hosts.empty?
  end

  def no_vulns_found?
    workspace.vulns.empty?
  end

  # Creates & memoizes the necessary RunStats
  def initialize_run_stats
    return if @run_stats.present?
    stats_hash = {
      :hosts_imported => RunStat.where(
        name: :hosts_imported,
        task_id: mdm_task.id
      ).first_or_create,
      :total_hosts => RunStat.where(
        name: :total_hosts,
        task_id: mdm_task.id
      ).first_or_create,
      :vulns_found => RunStat.where(
        name: :vulns_found,
        task_id: mdm_task.id
      ).first_or_create,
      :potential_exploits => RunStat.where(
        name: :potential_exploits,
        task_id: mdm_task.id
      ).first_or_create,
      :exploit_matches => RunStat.where(
        name: :exploit_matches,
        task_id: mdm_task.id
      ).first_or_create,
      :vuln_validations => RunStat.where(
        name: :vuln_validations,
        task_id: mdm_task.id
      ).first_or_create,
      :vuln_exceptions => RunStat.where(
        name: :vuln_exceptions,
        task_id: mdm_task.id
      ).first_or_create
    }
    stats_hash.each do |key, run_stat|
      if run_stat.data.nil?
        run_stat.data = 0
        run_stat.save!
      end
    end
    @run_stats = OpenStruct.new(stats_hash)
  end
end
