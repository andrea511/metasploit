class Notifications::MessagesController < ApplicationController
  DEFAULT_NOTIFICATION_PAGE_SIZE = 10

  def index
    messages = paginate_messages(load_messages).order('id DESC')
    workspace = Mdm::Workspace.find_by_id params[:workspace_id]
    presenter = Notifications::PollPresenter.new(
      :messages => messages,
      :workspace => workspace
    )
    respond_to do |format|
      format.json { render :json => presenter.as_json }
    end
  end

  # marks the user's instance of the message as READ
  #  in the notification_messages_users join table.
  def mark_read
    current_user.notification_center_count = 0
    current_user.save()

    user_messages = load_multiple_user_messages
    if user_messages.update_all :read => true
      render :json => {}, :status => :ok
    else
      render :json => {}, :status => :bad_request
    end
  end

  # destroys ONLY the notification_messages_user (join table)
  #  entry for the current_user and the specified message
  def destroy
    if load_message.users.delete(current_user)
      render :json => {}, :status => :ok
    else
      render :json => {}, :status => :bad_request
    end
  end

  # creates a Presenter that renders aggregated data into a JSON
  # API endpoint: recent messages, session count, task count, etc
  # for consumption by javascript.
  def poll
    message_count = current_user.notification_center_count
    workspace = Mdm::Workspace.find_by_id params[:workspace_id]
    presenter = Notifications::PollPresenter.new(
      unread_message_count: message_count,
      workspace: workspace
    )
    respond_to do |format|
      format.json { render :json => presenter.as_json }
    end
  end

  def last_request_update_allowed?
    action_name != 'index'
  end

  private

  # @return [ActiveRecord::Relation] of messages ordered correctly
  def load_messages
    messages = if params.has_key? :before
      # return last n messages
      Notifications::Message.for_user(current_user).where('notification_messages.id < ?', params[:before]).
          limit(params[:limit] || DEFAULT_NOTIFICATION_PAGE_SIZE).with_status()
    elsif params.has_key? :since # return all relevant messages AFTER this one
      Notifications::Message.for_user(current_user).where('notification_messages.id > ?', params[:since]).
          with_status()
    elsif params.has_key? :unread # return all unread messages
      Notifications::Message.unread_for_user(current_user).with_status()
    else  # return all messages
      Notifications::Message.for_user(current_user).with_status()
    end

    if params.has_key? :kind
      messages = messages.where(:kind => params[:kind])
    end

    if params[:workspace_id].present?
      messages = messages.where(:workspace_id => params[:workspace_id])
    end

    messages
  end

  # @return [ActiveRelation] relation of all MessagesUsers (join table)
  #   entries and JOINed Messages that map the the current user.
  def load_multiple_user_messages
    Notifications::MessagesUsers.where('message_id IN (?)', params[:message_ids])
                                .where(:user_id => current_user.id)
  end

  # @return [Notifications::Message] a single message
  def load_message(param_name=:id)
    Notifications::Message.find(params[param_name])
  end

  # @return [ActiveRelation] with added pagination and limit clauses
  def paginate_messages(messages)
    page = params[:page] || 1
    limit = params[:limit] || DEFAULT_NOTIFICATION_PAGE_SIZE
    messages.page(page).per(limit)
  end
end
