class BannerMessage < ApplicationRecord
  def self.get_unread(user_id)
    banner_message_ids = BannerMessageUser.
        where(user_id: user_id, read: true).
        map(&:banner_message_id)
    banner_messages = where.not(id: banner_message_ids).reject(&:admin)

    if Mdm::User.find(user_id).admin
      admin_banner_message_ids = BannerMessageUser.
          where(read: true).
          map(&:banner_message_id)
      banner_messages = banner_messages | where.not(id: admin_banner_message_ids).where(admin: true)
    end

    banner_messages
  end
end
