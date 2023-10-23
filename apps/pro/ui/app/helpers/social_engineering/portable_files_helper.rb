module SocialEngineering::PortableFilesHelper
    def portable_file_download_url
      campaign = @portable_file.campaign
      workspace = campaign.workspace
      download_workspace_social_engineering_campaign_portable_file_path(workspace, campaign, @portable_file) 
    end

  def portable_file_file_generation_type_pairs
    types_array = SocialEngineering::PortableFile::VALID_FILE_GENERATION_TYPES.map(&:humanize)
    replacements = {
      'Exe agent' => 'Executable file',
      'File format' => 'File format exploit',
    }
    types_array.map!{ |t| replacements[t] || t }
    Hash[types_array.zip SocialEngineering::PortableFile::VALID_FILE_GENERATION_TYPES]
  end

  def portable_file_payload_type_pairs
    types_array = SocialEngineering::PortableFile::VALID_PAYLOAD_TYPES.map(&:humanize)
    replacements = {
      'Reverse tcp' => 'Reverse TCP',
      'Reverse http' => 'Reverse HTTP',
      'Reverse https' => 'Reverse HTTPS'
    }
    types_array.map!{ |t| replacements[t] || t }
    Hash[types_array.zip SocialEngineering::PortableFile::VALID_PAYLOAD_TYPES]
  end

end
