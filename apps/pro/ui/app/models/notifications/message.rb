module Notifications
  class Message < ApplicationRecord
    self.table_name = :notification_messages

    #
    # Notification Kinds
    #
    NOTIFICATION_KINDS = %w(
        system_notification
        metamodule_notification
        task_notification
        update_notification
        report_notification
        export_notification
        credential_notification
        failed_notification
    )



    #
    # Associations
    #
    belongs_to :workspace, :class_name => 'Mdm::Workspace', optional: true
    belongs_to :task, :class_name => 'Mdm::Task', optional: true
    has_many :messages_users, 
             :class_name => 'Notifications::MessagesUsers',
             :dependent  => :destroy
    has_many :users, :through => :messages_users

    #
    # Validations
    #
    validates :title,   :presence => true
    validates :content, :presence => true
    validates :kind, inclusion: {in: NOTIFICATION_KINDS,message: "%{value} is not a valid notification kind"}

    #
    # Scopes
    #
    scope :for_workspace, lambda { |workspace| where(:workspace_id => workspace.id)}
    scope :for_user, lambda { |user|
      joins(:messages_users).where(
        'notification_messages_users.user_id = ?', user.id
      )
    }
    scope :with_status, lambda {
      message_table = Notifications::Message.arel_table
      message_user_table = Notifications::MessagesUsers.arel_table
      select([message_table[Arel.star], message_user_table[:read]])
    }
    scope :unread_for_user, lambda { |user|
      for_user(user).joins(:messages_users).where(
        'notification_messages_users.read = ?', false
      )
    }

    #
    # AR Hooks
    #
    after_create :send_notifications_and_increment

    #super opts.merge(:include => :messages_users)

    def as_json(args={})
      date_helpers = Object.new.extend ActionView::Helpers::DateHelper
      super().merge(:humanized_created_at => date_helpers.time_ago_in_words(self.created_at))
    end

    private

    def send_notifications_and_increment
        recipients = find_recipients
        populate_join_table!(recipients)
        increment_notification_count(recipients)
    end

    # Send the Notification to all users in a workspace, plus all administrators
    def populate_join_table!(recipients)
      self.users.push *recipients
    end

    # Increment Notification Counter
    def increment_notification_count(recipients)
        recipients.each{ |r| Mdm::User.increment_counter(:notification_center_count, r.id)}
    end

    # @return [Array<Mdm::User>] of users that should be notified
    def find_recipients
        unless self.workspace.nil?
            (self.workspace.users + Mdm::User.where(:admin => true)).uniq
        else
            Mdm::User.all
        end
    end
  end
end
