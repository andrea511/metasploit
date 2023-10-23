class BackupsController < ApplicationController
  protect_from_forgery except: :status
  skip_before_action :require_license, :only => [:status, :restart]
  skip_before_action :require_user, :only => [:status]
  before_action :require_admin, :except => [:status]

  def new
    render :action => 'new'
  end

  def create
    # Validate backup name
    if params[:name].length > 64
      @errors = { name_error: "Invalid length. Backup name cannot be more than 64 characters." }
      render :action => 'new', :status => :bad_request
    else
      archive = Backup.generate(params[:name], params[:description], overwrite: false, delay: true)
      if archive.errors.any?
        @errors = archive.errors
        render :action => 'new'
      else
        AuditLogger.admin "#{ip_user} - Backup started. name: #{params[:name]}, description: #{params[:description]}"
        redirect_to settings_path anchor: 'backups'
      end
    end   
  end

  def destroy
    params[:delete_backups].each do |backup|
      Backup.delete(backup)
      AuditLogger.admin "#{ip_user} - Backup deleted. name: #{backup}"
    end

    redirect_to settings_path anchor: 'backups'
  end

  def restore
    begin
      Backup.restore_alternate(params[:backup_name], delay: true)
      AuditLogger.admin "#{ip_user} - Backup restored. name: #{params[:backup_name]}"
      redirect_to restore_poll_path
    rescue RuntimeError => e
      flash[:error] = "\"#{params[:backup_name]}\" could not be restored: #{e}"
      redirect_to settings_path anchor: 'backups'
    end
  end

  def restore_poll
    @refresh = false
    @status = RestartStatus.get
    restore_job = Delayed::Job.where('handler LIKE \'%Backup%restore%\'').first
    if restore_job
      name = Psych.load_dj(restore_job.handler).args[0]
      @backup = Backup.new(name)
    end

    render :layout => 'static'
  end

  def restart
    @status = RestartStatus.get
    # if a backup is in progress wait to restart
    while Backup.running?
      sleep 0.4
    end
    success = @status.restart
    if not success
      flash[:error] = "Failed to restart"
    end
    redirect_to :action => :restore_poll
  end

  # XHR request
  def status
    name = params["backup"]
    @backup = Backup.new(name)
    @status = RestartStatus.get
    unless @status.restarting?
      if @backup.require_restart == true && !Backup.running?
        @backup.mark_restarted
        @status.restart
      end
    end
    render :partial => 'status'
  end

  def download
    backup = Backup.new(params[:backup_name])
    if backup.description.nil?
      flash[:error] = "\"#{params[:backup_name]}\" could not be downloaded: Backup does not exist"
      redirect_to settings_path anchor: 'backups'
    else
      send_file backup.zip_file
    end
  end

  def add
    render :action => 'add'
  end

  def upload
    # add upload code here, likely need to build a template view that may need to come from another endpoint
    error_msg = nil
    if params[:file_input].blank?
      error_msg = "No File Provided"
    else
      invalid_file_msg = "The file provided is not a valid backup."
      # write file to disk, validate file contents, consider if file contents can be validated from `tempfile` location
      upload_file = params[:file_input].tempfile

      if params[:file_input].content_type != 'application/zip'
        error_msg = flash[:error] = invalid_file_msg
      end
      # check for existing file
      existing_file = Backup.new(params[:file_input].original_filename)
      unless existing_file.ms_version.nil?
        error_msg = flash[:error] = invalid_file_msg
      else
        begin
          file_as_backup = Backup.new(upload_file, name_as_path: true, overwrite: false)
          if file_as_backup.ms_version.nil?
            error_msg = flash[:error] = invalid_file_msg
          end

          unless file_as_backup.compatible?
            error_msg = flash[:error] = "The file provided is not compatible with this version."
          else
            file = ::File.new(::File.join(Backup.locations.pro_backups_directory, params[:file_input].original_filename), "wb")
            file.write(upload_file.read)
            file.close
          end
        rescue JSON::ParserError => _e
          error_msg = flash[:error] = invalid_file_msg
        end
      end
    end

    if error_msg.present?
      flash[:error] = error_msg
      redirect_to :action => "add"
    else
      redirect_to settings_path anchor: 'backups'
    end
  end
end
