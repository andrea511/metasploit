class RcScriptsController < ApplicationController
  before_action :load_workspace
  before_action :using_embedded_layout?
  layout :task_layout_selector

  include TasksSharedControllerMethods
  include TableResponder

  has_scope :workspace_id, only: [:index]

  require 'msf/base/config'

  def index
    @rc_scripts = Dir.glob(locations.pro_rc_scripts_directory+"/*").map do |d|
      {
          filename: d.split('/').last,
          source: 'Custom',
          created_date: File.ctime(d)
      }
    end

    @canned_rc_scripts = Dir.glob(canned_rc_script_dir+"/*").map do |d|
      {
        filename: d.split('/').last,
        source: 'Framework',
        created_date: File.ctime(d)
      }
    end

    render layout: !request.xhr?
  end

  def upload
    File.open("#{locations.pro_rc_scripts_directory}/#{params['upload'].original_filename}", 'wb') do |file|
      file.write(params["upload"].tempfile.read)
    end
    redirect_to action: 'index'
  end

  def rc_script_delete
    delete_file = locations.pro_rc_scripts_directory + "/" + params['path'].split('/').last
    File.delete(delete_file)
    redirect_to action: 'index'
  end

  def rc_script_run
    rc_task = RcLaunchTask.new(
      params.merge({
          workspace: @workspace,
          username: @current_user.username,
          rc_path: rc_script_full_path(params[:path], params[:canned_script])
      })
    )

    if (task = rc_task.start)
      if request.xhr?
        render_js_redirect(task_detail_url(task.workspace, task))
      else
        redirect_to task_detail_url(task.workspace, task)
      end
    else
      render 'errors_update', :locals => { :task => rc_task }
    end
  end

  def show
    @rc_script = rc_script_to_hash(
        params[:path],
        params[:canned_script],
        params[:datastore_opts],
        true
    )
  end

end

