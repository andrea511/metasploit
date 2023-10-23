require 'carrierwave'
require 'carrierwave/orm/activerecord'
#require 'carrierwave/processing/mime_types'


class PayloadUploader < CarrierWave::Uploader::Base
  storage :file

  # returns path to daemon-writable campaign_files folder
  def payload_files_path
    # We can't use Rails.root here because this code is sometimes called
    # from prosvc, which includes the Rails library but has no sense of a
    # configured Rails application
    File.join(File.dirname(__FILE__), '../../../payload_files')
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    File.join(payload_files_path, "#{mounted_as}/#{model.id}")
  end

  # should return path for storing files temporarily while they are processed
  def cache_dir
    File.join(payload_files_path, 'tmp')
  end

end
