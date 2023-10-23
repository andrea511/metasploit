class Admin::UsersController < ApplicationController
  before_action :require_admin

  def index
    @users = Mdm::User.order('username')
  end

  def new
    @user = Mdm::User.new(:workspaces => Mdm::Workspace.all)
    @user.time_zone = current_user.time_zone
  end

  def create
    params[:user][:workspace_ids] ||= []
    @user = Mdm::User.new(user_params)
    if @user.save
      projects = if @user.admin
        'all projects'
      else
        "projects: #{@user.accessible_workspaces.pluck(:name)}"
      end
      AuditLogger.user("#{ip_user} - Created user #{@user.as_json.slice('username', 'email', 'admin')} via admin panel with access granted to #{projects}")
      redirect_to admin_users_path
    else
      render :action => 'new'
    end
  end

  def edit
    @current_user = current_user
    @user = Mdm::User.find(params[:id])
  end

  # TODO: A lot of this code is duplicated in the users_controller. I don't
  # see a valid reason for keeping these as separate controllers.
  def update
    @user = Mdm::User.find(params[:id])
    @current_user = current_user
    user_attrs = user_params
    user_attrs[:workspace_ids] ||= []

    # user update cannot remove access to owned workspaces
    user_attrs[:workspace_ids] = user_attrs[:workspace_ids].push(*@user.owned_workspace_ids).uniq

    # password is only required when an admin is modifying his own password
    if @current_user == @user && user_attrs.has_key?(:password)
      old_password_fail = !(@user.valid_password? user_attrs[:password_old])
      user_attrs.delete :password_old
    end

    old_user = @user.as_json
    old_user['projects'] = @user.accessible_workspaces.pluck(:name)

    if !old_password_fail && @user.update(user_attrs)
      new_user = @user.as_json
      new_user['projects'] = @user.accessible_workspaces.pluck(:name)
      AuditLogger.user("#{ip_user} - User #{@user.as_json.slice('username', 'email')} updated via admin panel #{AuditHelper.compare(old_user, new_user, filter: ['crypted_password'], same: false).slice('username', 'email', 'fullname', 'company', 'time_zone', 'crypted_password', 'projects', 'admin')}")
      flash[:notice] = "User '#{@user.username}' updated"
      redirect_to admin_users_path
    elsif old_password_fail
      AuditLogger.user("#{ip_user} - Failed to update password via admin panel")
      @user.errors.add :original_password, 'is incorrect.'
      render :action => 'edit'
    else
      render :action => 'edit'
    end
  end

  def destroy
    users = if params[:id]
              [Mdm::User.find(params[:id])]
            elsif params[:user_ids]
              Mdm::User.find(params[:user_ids])
            else
              []
            end
    attempted_current_user_deletion = users.delete(current_user) # don't allow current_user to be deleted
    usernames = users.map(&:username)
    Mdm::User.where(id: users.map(&:id)).destroy_all
    if attempted_current_user_deletion and users.empty?
      flash[:error] = "You cannot delete the currently logged-in user"
    elsif users.empty?
      flash[:error] = "No users selected to delete"
    else
      num_users = view_context.pluralize(users.length, "user")
      AuditLogger.user("#{ip_user} - Deleted #{num_users} via admin panel: #{usernames}")
      flash[:notice] = num_users + " deleted"
    end

    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:username, :fullname, :password_old, :password, :password_confirmation, :time_zone, :email, :company, :admin, workspace_ids: [])
  end
end
