#require presenter not in lib, should this really be a presenter?
require 'mdm/vuln_attempt/status'
module ::Nexpose::Result::Export
  # @return [Nexpose::Result::ExportRun] to pass over the RPC bridge
  def create_export_run
    Nexpose::Result::ExportRun.create(
      :workspace => @workspace,
      :user => current_user
    )
  end

  # @return [Nexpose::Result::ExportRun] to pass over the RPC bridge
  def generate_export_run_for_workspace_vulns
    export_run = create_export_run
    selected_vuln_ids = @workspace.vuln_ids
    match_results = MetasploitDataModels::AutomaticExploitation::MatchResult.for_vuln_id(selected_vuln_ids)
    validations = create_validations(match_results.succeeded, export_run)
    Nexpose::Result::Validation.create(validations)
    exceptions = create_exceptions(selected_vuln_ids, export_run)
    filter_validated_exceptions!(validations, exceptions)
    Nexpose::Result::Exception.create(exceptions)
    export_run
  end

  # @return [Array] of validation attribute hashes
  def create_validations(validation_match_results, export_run)
    validations = []
    validation_match_results.each do |match_result|
      match_result.match.matchable.host.nexpose_assets.each do |asset|
        validations << {
          :user => current_user,
          :nx_asset => asset,
          :export_run => export_run,
          :match_result => match_result,
          :verified_at => match_result.created_at
        }
      end
    end
    validations
  end

  # @return [Array] of Exception attribute hashes
  def create_exceptions(vuln_ids, export_run)
    create_match_failures(vuln_ids,export_run)
    match_results = MetasploitDataModels::AutomaticExploitation::MatchResult.for_vuln_id(vuln_ids)

    exceptions = []
    match_results.each do |match_result|
      match_result.match.matchable.host.nexpose_assets.each do |asset|
        exceptions << {
          :user => current_user,
          :nx_scope => asset,
          :export_run => export_run,
          :reason => params[:reason],
          :expiration_date => (params[:expiration_date]||'').empty? ? nil : Date.strptime(params[:expiration_date],"%m/%d/%Y").to_time,
          :approve => params[:approve],
          :comments => params[:comments],
          :match_result => match_result
        }
      end
    end
    exceptions
  end

  # Allow exceptions to take precedence over validations when same asset and vuln definition
  # @return [Array] the filtered exceptions as attribute hashes
  def filter_validated_exceptions!(validations, exceptions)
    exceptions.reject!{|ex| reject_exception?(validations, ex) }
  end

  def reject_exception?(validations, exception)
    reject_exception = false
    validations.each do |val|
      reject_exception = exception[:nx_scope].asset_id == val[:nx_asset].asset_id &&
        exception[:match_result].match.matchable.nexpose_data_vuln_def_id == val[:match_result].match.matchable.nexpose_data_vuln_def_id
      break if reject_exception
    end
    reject_exception
  end

  # Create match result failures for vulns pushable as exceptions that dont have them
  # This covers the case where a module runs, fails to gain a session but doesn't create a
  # match result and the user marks it as "Not Exploitable"
  # @return nil
  def create_match_failures(vuln_ids,export_run)
    vulns_with_pushable_exceptions = Mdm::Vuln.joins(:vuln_attempts)
                                         .where('vulns.id' => vuln_ids)
                                         .where('vuln_attempts.fail_reason' => Mdm::VulnAttempt::Status::NOT_EXPLOITABLE)
                                         .distinct

    #TODO: Optimize into a query that gets all the vulns that need match results created
    # For each vuln that is pushable as an exception we check if a match result exists.
    # If not, we create an match result with a failure
    vulns_with_pushable_exceptions.each do |vuln|
      if MetasploitDataModels::AutomaticExploitation::MatchResult.for_vuln_id(vuln).failed.count == 0
        MetasploitDataModels::AutomaticExploitation::MatchResult.create!(
          match: MetasploitDataModels::AutomaticExploitation::Match.by_vuln_id(vuln.id).last,
          state: MetasploitDataModels::AutomaticExploitation::MatchResult::FAILED,
        )
      end
    end
  end

  # Calls the Push Exceptions module across the RPC bridge, passing the export_run ID
  # @return [Integer] the id of the spawned Mdm::Task
  def launch_with_export_run(export_run)
    # make the RPC call and redirect to task page
    Nexpose::ExceptionValidationPush::TaskConfig.new(
      :workspace => @workspace,
      :export_run_id => export_run.id
    ).rpc_call["task_id"]
  end

end
