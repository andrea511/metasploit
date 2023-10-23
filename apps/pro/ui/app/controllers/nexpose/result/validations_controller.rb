class ::Nexpose::Result::ValidationsController < ApplicationController
  before_action :load_workspace

  include ::Nexpose::Result::Export

  def create
    respond_to do |format|
      format.json {
        create_single_validation
      }
    end
  end

  def show
    respond_to do |format|
      format.json{
        validation = Nexpose::Result::Validation.select([
                                                          Nexpose::Result::Validation[:sent_to_nexpose],
                                                          Nexpose::Result::Validation[:nexpose_response]
                                                        ]).joins(
          Nexpose::Result::Validation.join_association(:export_run)
        ).where(
          Nexpose::Result::Validation[:id].eq(params[:id]),
          Nexpose::Result::ExportRun[:workspace_id].eq(@workspace.id)
        )

        render json: validation
      }
    end
  end

  private

  def create_single_validation
    export_run = create_export_run
    match_results = MetasploitDataModels::AutomaticExploitation::MatchResult.for_vuln_id([params[:vuln_id]])
    validations = create_validations(match_results.succeeded, export_run)
    validations = ::Nexpose::Result::Validation.create(validations)

    tid = launch_with_export_run(export_run)
    render json: {:success => :ok, :task_id => tid, redirect_url: task_detail_path(@workspace.id, tid), id: validations[0].id}
  end

end
