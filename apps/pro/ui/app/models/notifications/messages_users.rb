# join table for mapping Mdm::User <-> Notification::Message
module Notifications
  class MessagesUsers < ApplicationRecord
    self.table_name = :notification_messages_users

    #
    # Associations
    #
    belongs_to :message, :class_name => 'Notifications::Message'
    belongs_to :user, :class_name => 'Mdm::User'

  end
end
