class BannerMessagesController < ApplicationController
  def index
    @banner_messages = BannerMessage.get_unread(current_user.id)
    render json: get_localized_banner_messages(@banner_messages)
  end

  def read
    BannerMessageUser.create(user_id: current_user.id,
                   banner_message_id: params[:banner_id],
                                read: true)
    render json: {}
  end

  def get_localized_banner_messages(banner_messages)
    banner_messages.map do |banner_message|
      serialized_banner_message = banner_message.serializable_hash
      localized_message = I18n.t("notifications.banner_messages.#{banner_message.name}")
      serialized_banner_message['title'] = localized_message[:title]
      serialized_banner_message['message'] = localized_message[:message]
      serialized_banner_message
    end
  end
end
