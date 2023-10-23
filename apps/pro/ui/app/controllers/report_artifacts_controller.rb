class ReportArtifactsController < ApplicationController

  before_action :load_workspace
  before_action :fetch_report_artifact, only: [:view, :download, :destroy]

  def view
    download(:inline)
  end

  def download(disposition = :attachment)
    artifact_filename = File.basename(@report_artifact.file_path)
    artifact_extension = File.extname(@report_artifact.file_path)[1..-1]

    file_types = {
      'html' => 'text/html',
      'pdf'  => 'application/pdf',
      'rtf'  => 'application/rtf',
      'docx' => 'application/msword',
      'xml'  => 'application/xml',
      'txt'  => 'text/plain',
      'zip'  => 'application/zip'
    }
    current_type = file_types[artifact_extension]

    file_data = File.open(@report_artifact.file_path, 'rb') { |f| f.read }
    send_data(file_data,
              type: current_type,
              disposition: disposition,
              filename: artifact_filename)

    @report_artifact.accessed_at = Time.now.utc
    @report_artifact.save
  end

  def destroy
    @report_artifact.destroy

    respond_to do |format|
      format.js { render json: { success: true } }
    end
  end

  def email
    report = @workspace.reports.find(params[:report_id])
    report_artifact_ids = params[:report_artifact_ids]

    respond_to do |format|
      format.js do
        if report.delay.email_report(report.id, params[:recipients], params[:report_artifact_ids])
          render json: { success: true, message: 'Email queued for delivery.' }
        else
          render json: { error: true, message: 'There was a problem sending the email.' }
        end
      end
    end
  end

  private

  def fetch_report_artifact
    @report_artifact = @workspace.reports.find(params[:report_id]).report_artifacts.find(params[:id])
  end

end


