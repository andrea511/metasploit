class ::Nexpose::Result::ExceptionsController < ApplicationController
  before_action :load_workspace

  include ::Nexpose::Result::Export

  def create
    respond_to do |format|
      format.json {
          create_single_exception
      }
    end
  end

  def show
    respond_to do |format|
      format.json{
        exception = Nexpose::Result::Exception.select([
                                                        Nexpose::Result::Exception[:sent_to_nexpose],
                                                        Nexpose::Result::Exception[:nexpose_response]
                                                      ]).joins(
          Nexpose::Result::Exception.join_association(:export_run)
        ).where(
          Nexpose::Result::Exception[:id].eq(params[:id]),
          Nexpose::Result::ExportRun[:workspace_id].eq(@workspace.id)
        )

        render json: exception
      }
    end
  end

  private

  # Push a single exception
  def create_single_exception
    export_run = create_export_run
    exceptions = create_exceptions(params[:vuln_id], export_run)
    exceptions = ::Nexpose::Result::Exception.create(exceptions)
    tid = launch_with_export_run(export_run)

    render json: { :task_id => tid, redirect_url: task_detail_path(@workspace.id, tid), id: exceptions[0].id}
  end


end
