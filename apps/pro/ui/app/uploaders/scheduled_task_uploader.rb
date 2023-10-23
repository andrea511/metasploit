# encoding: utf-8

# Handles uploading images.  It is currently mounted on {Web::Proof} as {Web::Proof#image} to handle screen shots of the
# manual XSS browser.
class ScheduledTaskUploader < CarrierWave::Uploader::Base
  storage :file

  # Restrict to a subset of image extension.
  #
  # @return [String]
  def extension_white_list
    %w(txt xml zip key lst)
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

  # TODO A permanent home should be found for files like this:
  def self.upload_dir
    pro_pathname.join('ui', 'public', 'uploads')
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
    self.class.upload_dir.join('workspace', 'scheduled_tasks')
  end

  # should return path for storing files temporarily while they are processed
  def cache_dir
    self.class.upload_dir.join('tmp', 'scheduled_tasks')
  end

end
