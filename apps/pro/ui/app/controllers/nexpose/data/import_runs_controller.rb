class ::Nexpose::Data::ImportRunsController < ApplicationController
  before_action :load_workspace

  def create
    @console = Mdm::NexposeConsole.find params[:nexpose_console_id]
    import_run = NexposeImporter.new(
      console:@console,
      current_user: current_user,
      workspace:@workspace
    ).run

    respond_to do |format|
      format.json do
        render json: import_run.as_json.merge(
                 :templates => Nexpose::Data::ScanTemplate.where(:nx_console_id => import_run.console.id)
               )
      end
    end
  end

  def show
    @import_run = ::Nexpose::Data::ImportRun.find(params[:id])

    respond_to do |format|
      format.json do

        render json: @import_run.as_json.merge(
                 :templates => Nexpose::Data::ScanTemplate.where(:nx_console_id => @import_run.console.id)
               )
      end
    end
  end

end
