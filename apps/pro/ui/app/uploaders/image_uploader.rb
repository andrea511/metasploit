# encoding: utf-8

# Handles uploading images.  It is currently mounted on {Web::Proof} as {Web::Proof#image} to handle screen shots of the
# manual XSS browser.
class ImageUploader < CarrierWave::Uploader::Base
  storage :file

  # Restrict to a subset of image extension.
  #
  # @return [String]
  def extension_white_list
     %w(jpg jpeg gif png)
  end

  # Returns pathname of __FILE__
  #
  # @return [Pathname] `Pathname.new(__FILE__)`
  def self.file_pathname
    Pathname.new(__FILE__)
  end

  # Calculates Pathname to pro directory from {rails_root}.
  #
  # @return [Pathname] .../pro
  def self.pro_pathname
    rails_root.parent
  end

  # Calculates the Rails.root from __FILE__ so it works when used outside of Rails, such as in prosvc.
  #
  # @return [Pathname]
  # @see file_pathname
  def self.rails_root
    file_pathname.parent.parent.parent
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    self.class.pro_pathname.join('uploads', model.class.to_s.underscore, mounted_as.to_s, model.id.to_s)
  end
end
