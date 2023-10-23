# Explicitly require carrierwave so mount_uploader is defined for prosvc
require 'carrierwave/orm/activerecord'

class SocialEngineering::CampaignFile < ApplicationRecord
  self.table_name = :se_campaign_files

  #
  # CONSTANTS
  #

  VALID_CONTENT_DISPOSITIONS = ["attachment", "inline"]

  #
  # Associations
  #

  belongs_to :attachable, :polymorphic => true, :optional => true

  #
  # Callbacks
  #

  before_validation(:on => :create) do
    if self.content_disposition.blank?
      self.content_disposition = "attachment"
      true
    end
  end

  #
  # Uploaders
  #

  mount_uploader :attachment, SocialEngineering::CampaignFileUploader

  #
  # Validations
  #

  validates :content_disposition, :inclusion => VALID_CONTENT_DISPOSITIONS, :presence => true

  def attachment_url
    "/campaign_files/#{id}"
  end

  # For setting a MIME message part's Content-ID header
  def content_id
    @content_id ||= Rex::Text.to_hex(attachment.identifier + id.to_s, '')
  end

  attr_writer :content_id

  def to_s
    attachment.to_s
  end
end
