module NotificationsHelper
  # @return [Integer] the id of the last known notification (read or unread)
  def last_known_notification_id
    return '' if current_user.nil?
    @last_known_notification ||= Notifications::Message.for_user(current_user).last
    if @last_known_notification.present?
      @last_known_notification.id
    else
      ''
    end
  end

  # @return [Integer] the number of unread notifications
  def unread_notification_count
    return 0 if current_user.nil?
    @notification_count ||= current_user.notification_center_count
  end
end