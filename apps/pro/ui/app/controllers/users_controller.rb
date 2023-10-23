class UsersController < ApplicationController
  skip_before_action :require_user
  skip_before_action :require_license
  before_action :redirect_if_user_exists, :only => [:new, :create]
  before_action :check_request_verified, :only => [:create]

  # See MSP-12165, prevent initial user creation via CSRF:
  def check_request_verified
    redirect_to root_path unless verified_request?
  end

  def new
    if (request.remote_ip == "127.0.0.1" or request.remote_ip == "::1")
      @user = Mdm::User.new
      @user.time_zone = "UTC" # default to UTC
      render :action => 'new'
    else
      @server_url = "127.0.0.1" + request.port_string
      render "generic/welcome"
    end
  end

  def create
    if (request.ip == "127.0.0.1" or request.ip == "::1")

      @user = Mdm::User.new(users_params)
      @user.admin = true
      if @user.save
        # flash[:notice] = "User account created"
        AuditLogger.user("#{request.ip} - #{@user.username} - Creating initial admin user: #{@user.as_json.slice('username', 'email')}.")
        @user_session = UserSession.new(:username => @user.username, :password => @user.password)
        if @user_session.save
          redirect_to root_path
        else
          redirect_to login_path
        end
      else
        render :action => 'new'
      end
    else
      redirect_to root_path
    end
  end

  def edit
    @user = current_user
    @current_user = @user
    if not @user
      redirect_to root_path
      return
    end
  end

  def update
    @user = current_user

    if not @user
      redirect_to root_path
      return
    end

    user_attrs = users_params
    old_user = @user.as_json

    # Protect these attributes from modification
    user_attrs.delete(:admin)
    user_attrs.delete(:workspace_ids)

    # Block a sneaky way to bypass these checks
    user_attrs.delete(:attributes)
    user_attrs.delete('attributes')

    # Require old password to change
    if user_attrs.has_key? :password
      old_password_fail = !(@user.valid_password? user_attrs[:password_old])
      user_attrs.delete :password_old
    end

    if !old_password_fail && @user.update(user_attrs)
      AuditLogger.user("#{ip_user} - User #{@user.as_json.slice('username', 'email')} updated #{AuditHelper.compare(old_user, @user.as_json, filter: ['crypted_password'], same: false).slice('username', 'email', 'fullname', 'company', 'time_zone', 'crypted_password')}")
      flash[:notice] = "Updated #{h @user.username}"
      redirect_to root_path
    else
      if old_password_fail
        AuditLogger.user("#{ip_user} - Failed to update password")
        @user.errors[:current_password] = 'is incorrect.'
      end
      @current_user = @user
      render :action => 'edit'
    end
  end

  private

  def redirect_if_user_exists
    redirect_to root_path if user_exists?
  end

  def users_params
    params.fetch(:user, {}).permit(:username, :password_old, :password, :password_confirmation, :fullname, :email, :company, :time_zone)
  end
end

