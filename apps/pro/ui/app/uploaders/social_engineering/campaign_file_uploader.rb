# encoding: utf-8
require 'carrierwave'
require 'carrierwave/orm/activerecord'

class SocialEngineering::CampaignFileUploader < CarrierWave::Uploader::Base

  process :set_content_type
  storage :file

  # returns path to daemon-writable campaign_files folder
  def campaign_files_path
    # We can't use Rails.root here because this code is sometimes called
    # from prosvc, which includes the Rails library but has no sense of a
    # configured Rails application
    File.join(File.dirname(__FILE__), '../../../../campaign_files')
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    File.join(campaign_files_path, "#{mounted_as}/#{model.id}")
  end

  # should return path for storing files temporarily while they are processed
  def cache_dir
    File.join(campaign_files_path, 'tmp')
  end

  # -- HACK -- 
  # The existing set_content_type instance method doesn't appear to set
  # ivars like it's supposed to.  But it DOES return a MIME string, so this
  # should work for now.
  alias :set_content_type :content_type
end
