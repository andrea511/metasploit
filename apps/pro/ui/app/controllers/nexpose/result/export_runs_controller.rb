class ::Nexpose::Result::ExportRunsController < ApplicationController
  before_action :load_workspace

  include TableResponder
  include FilterResponder
  include ::Nexpose::Result::Export

  has_scope :workspace_id

  def create
    export_run = create_export_run
    selected_vuln_ids = load_filtered_records(Mdm::Vuln, params).pluck(:id)
    match_results = MetasploitDataModels::AutomaticExploitation::MatchResult.for_vuln_id(selected_vuln_ids)
    validations = create_validations(match_results.succeeded, export_run)
    Nexpose::Result::Validation.create(validations)
    exceptions = create_exceptions(selected_vuln_ids, export_run)
    filter_validated_exceptions!(validations, exceptions)
    Nexpose::Result::Exception.create(exceptions)

    tid = launch_with_export_run(export_run)
    render json: { :success => :ok, :task_id => tid, redirect_url: task_detail_path(@workspace.id, tid)}
  end


end
