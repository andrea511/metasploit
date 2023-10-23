# encoding: utf-8

class SocialEngineering::WebTemplateUploader < SocialEngineering::CampaignFileUploader
  def extension_white_list
    %w(zip)
  end
end
