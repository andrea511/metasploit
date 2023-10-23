# Sets a root dir for CarrierWave uploads
# also loaded by prosvc.rb
# remainder of path is set in app/uploaders/social_engineering/campaign_file_uploader 
require 'carrierwave'

file_root_dir = File.expand_path(File.join(File.dirname(__FILE__), "../../public"))

CarrierWave.configure do |config|
  config.root = file_root_dir
end
