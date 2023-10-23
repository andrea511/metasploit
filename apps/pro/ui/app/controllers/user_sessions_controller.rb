class UserSessionsController < ApplicationController

  skip_before_action :require_user
  skip_before_action :require_license

  layout "login"

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(user_session_params)

    remote_ip = request.ip
    user_agent = request.env['HTTP_USER_AGENT'].to_s

    if @user_session.save
      user = @user_session.record
      user.last_login_address = remote_ip
      user.session_key = session[:session_id]
      user.save!

      AuditLogger.authentication "#{remote_ip} - #{user.username} - Successful login."
      login_event(user.username, true, remote_ip, user_agent)

      redirect_back_or_default root_path
    else
      login_event(@user_session.username, false, remote_ip, user_agent)

      if @user_session.being_brute_force_protected?
        AuditLogger.security "#{remote_ip} - [NONE] - Account locked. Successive invalid login attempts."
        flash[:error] = 'Your account has been locked due to successive invalid login attempts. Please try again later.'
      else
        AuditLogger.authentication "#{remote_ip} - [NONE] - Failed login. Invalid username or password."
        flash[:error] = 'Invalid username or password.'
      end

      redirect_to login_path
    end
  end

  def destroy
    @user_session = UserSession.find

    AuditLogger.authentication "#{request.ip} - #{@user_session.record.username} - Successful logout."
    logout_event(@user_session.record.username, request.ip, request.env['HTTP_USER_AGENT'].to_s)

    @user_session.destroy
    flash[:notice] = "You have been logged out."
    redirect_to root_path
  end

  private

  def log_unverified_request(username, details)
    ip_user = "#{request.ip} - #{username}"
    AuditLogger.security "#{ip_user} - Failed login attempt. Invalid CSRF token. Details: #{details}."
    unless username == '[NONE]'
      AuditLogger.security "#{ip_user} - User #{username} already logged in."
    end
  end

  private

  def user_session_params
    params.require(:user_session).permit(:username, :password).to_h
  end

  def login_event(username, success, remote_ip, user_agent)
    ev = Mdm::Event.new(:name => "user_login",
                        :username => username,
                        :info => {:success => success,
                                  :address => remote_ip,
                                  :user_agent => user_agent})
    ev.save!
  end

  def logout_event(username, remote_ip, user_agent)
    ev = Mdm::Event.new(:name => "user_logout",
                        :username => username,
                        :info => {:address => remote_ip,
                                  :user_agent => user_agent})
    ev.save!
  end

end
