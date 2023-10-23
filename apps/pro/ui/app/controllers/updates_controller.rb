class UpdatesController < ApplicationController

  skip_before_action :require_license, :only => [:status, :restart]
  skip_before_action :require_user, :only => [:status]
  before_action :require_admin, :except => [:status]

  def updates
    @status = UpdateStatus.get
    if @status.in_progress?
      render :action => :in_progress
    else
      @license = License.get
      set_http_proxy
      render :action => :updates
    end
  end

  # XHR request
  def status
    @status = UpdateStatus.get
    render :partial => 'status'
  end

  # XHR request
  def check

    #Do not allow 32-bit updating
    if ['metasploit'].pack('p').size == 4
      flash[:error] = "32-bit installations of Metasploit on all platforms will no longer receive updates."
    end

    proxy_params = if params[:use_proxy]
      @current_user.update(current_user_params)
      { :proxy_host => @current_user.http_proxy_host,
      :proxy_port => @current_user.http_proxy_port,
      :proxy_user => @current_user.http_proxy_user,
      :proxy_pass => @current_user.http_proxy_pass }
    else
      {}
    end
    @update = UpdateCheck.new(proxy_params)
    audit_view = @update.as_json
    unless proxy_params.empty?
      audit_view['proxy_params'].merge!({'proxy_pass' => '[FILTERED]'})
    end
    AuditLogger.admin "#{ip_user} - Manual update check. #{audit_view}"

    if @update.metrics
      # thread this blocking call, that can cause significant delays on large customer datasets
      metric_processor = Rex::ThreadFactory.spawn("Usage Metrics Processor", false) do
        error = UsageMetrics.update(proxy_params || {})
        unless error.nil?
          elog("Error: #{error}")
        end
      end
      metric_processor.priority = -10
    end

    render :partial => 'update', :locals => { :update => @update }
  end

  # Starts the update install
  def apply

    #Do not allow 32-bit updating
    if ['metasploit'].pack('p').size == 4
      flash[:error] = "32-bit installations of Metasploit on all platforms will no longer receive updates."
    end

    proxy_params = if params[:use_proxy]
      @current_user.update(current_user_params)
      { :proxy_host => @current_user.http_proxy_host,
      :proxy_port => @current_user.http_proxy_port,
      :proxy_user => @current_user.http_proxy_user,
      :proxy_pass => @current_user.http_proxy_pass }
    else
      {}
    end
    @update = UpdateCheck.new(proxy_params)
    success = @update.apply
    if not success
      flash[:error] = "Update failed to start: #{@update.error}"
      redirect_to :action => :updates
    else
      @status = UpdateStatus.get
      render :action => :in_progress
    end
  end

  # Serves the Offline update form
  def offline_apply

    #Do not allow 32-bit updating
    if ['metasploit'].pack('p').size == 4
      flash[:error] = "32-bit installations of Metasploit on all platforms will no longer receive updates."
    end

    @license = License.get

    unless UpdateOffline.supported?
      redirect_to :action => :updates
    end

    @status = UpdateStatus.get
    if @status and @status.in_progress?
      render :action => :in_progress
    end
  end

  # Handle the offline update file upload
  # I take no credit for this. All I did was move this code to a new safe route!
  # Don't blame me! It's not my fault! I just fix the bug! - joev
  def offline_apply_post
    @license = License.get

    unless UpdateOffline.supported?
      redirect_to :action => :updates
    end

    temp = nil
    if params[:update_file]
      # Copy the uploaded file to a tempfile
      temp = ::Rex::Quickfile.new('update')
      uploaded_io = params[:update_file]

      begin
        while (buff = uploaded_io.read(1024*64))
          temp.write(buff)
        end
      rescue ::EOFError
      end

      temp.flush
    end

    if temp.nil?
      flash[:error] = "No offline update file specified."
    else
      @update = UpdateOffline.new

      # Explicitly close the file to prevent locking issues
      path = temp.path
      temp.close rescue nil

      success = @update.apply(path)
      if not success
        flash[:error] = "Update failed to start: #{@update.error}"
      end      
    end

    redirect_to :action => :offline_apply
  end

  # Restarts prosvc
  def restart
    @status = UpdateStatus.get
    success = @status.restart
    if not success
      flash[:error] = "Failed to restart"
    end
    redirect_to :action => :updates
  end

  private

  # Defaults the http proxy settings to the globally stored proxy settings.
  #
  # Returns nothing.
  def set_http_proxy
    @current_user.http_proxy_host = current_profile.settings["http_proxy_host"] if @current_user.http_proxy_host.blank?
    @current_user.http_proxy_port = current_profile.settings["http_proxy_port"] if @current_user.http_proxy_port.blank?
    @current_user.http_proxy_user = current_profile.settings["http_proxy_user"] if @current_user.http_proxy_user.blank?
    @current_user.http_proxy_pass = current_profile.settings["http_proxy_pass"] if @current_user.http_proxy_pass.blank?
  end
end
