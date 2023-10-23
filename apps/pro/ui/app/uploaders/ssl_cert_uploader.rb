require 'carrierwave'
require 'carrierwave/orm/activerecord'
#require 'carrierwave/processing/mime_types'

class SSLCertUploader < CarrierWave::Uploader::Base
  storage :file

  # Defines where uploaded SSL Certs should be
  # temporarily stored while they are processed
  #
  # @return [String] the path to the SSL Certs temp dir
  def cache_dir
    File.join(cert_files_path, 'tmp')
  end

  # Defines the file system path to store uploaded
  # SSL Certs to.
  #
  # @return [String] the path to the SSL Certs directory
  def cert_files_path
    # We can't use Rails.root here because this code is sometimes called
    # from prosvc, which includes the Rails library but has no sense of a
    # configured Rails application
    File.join(File.dirname(__FILE__), '../../../ssl_certs')
  end

  # Defines the path to where a given SSL Cert should be
  # stored inside the SSL Certs directory.
  #
  # @return [String] the individual path to store a given SSL cert in
  def store_dir
    File.join(cert_files_path, "#{mounted_as}/#{model.id}")
  end
end
