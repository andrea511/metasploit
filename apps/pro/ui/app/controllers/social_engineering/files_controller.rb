module SocialEngineering
  class FilesController < ApplicationController
    before_action :load_workspace, :except => :download
    layout false
    respond_to :html, :js

    def index
      finder = ::UserSubmittedFilesFinder.new(@workspace)
      render :json => DataTableQueryResponse.new(finder, params).to_json
    end

    def destroy
      file_ids = params[:user_submitted_file_ids] || []
      if file_ids.empty?
        render :json => {:error =>  'No files were selected'}, :status => :bad_request
      else
        begin
          UserSubmittedFile.destroy(file_ids)
          head :ok
        rescue Errno::EACCES => e
          render :json => {:error =>  e.message}, :status => :bad_request
        end
      end
    end

    def new
        @file = UserSubmittedFile.new
    end

    def create
      begin
        @file = UserSubmittedFile.new(file_params[:social_engineering_user_submitted_file])
        @file.workspace_id = @workspace.id
        @file.user_id = current_user.id
        if @file.save
          render :partial => 'create_success'
        else
          # Not the best error message, but the JS expects a success without the magic meta tag
          @file.errors.add(:base, "Unable to save file")
          render :action => "new"
        end
      rescue Errno::EACCES
        pathname = Pathname.new SocialEngineering::CampaignFileUploader.new.campaign_files_path
        @file = UserSubmittedFile.new
        @file.errors.add(:base, "Permissions error. Unable to write to #{pathname.realpath}")
        render :action => :new
      end
    end

    def download
      # serve file here!!!!!!!!!!!!!!!~!!~!!!!!~
      @file = CampaignFile.find(params[:id])
      File.open(@file.attachment.path, 'rb') do |file|
        send_data file.read,
        :type => 'application/x-octet-stream',
        :disposition => 'attachment',
        :filename => File.basename(@file.attachment.path)
      end
    end

    def file_params
      params.permit!
    end
  end
end

