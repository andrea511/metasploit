
Se = SocialEngineering


def build_campaign_with_file_format_component
  Se::Campaign.transaction do
  user = Mdm::User.first
  workspace = Mdm::Workspace.first
  campaign = Se::Campaign.create(:user => user, :workspace => workspace, :name => "File Format Test")

  puts "Created campaign"
  puts "#{campaign.inspect}"

  page_data = {
    "name"        => "format1", 
    "path"        => "format1", 
    "attack_type" => "file", 
    "file_generation_type" => "file_format",
    "exploit_module_path" => "exploit/windows/fileformat/adobe_cooltype_sing",
    "exploit_module_config" => {
      "FILENAME" => "msf1.pdf"
    },
    "origin_type" => "custom",  
    "campaign_id" => campaign.id,
    "content"     => "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\"\r\n\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r\n\r\n<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\">\r\n\t<head>\r\n\t\t<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>\r\n\t\t\r\n\t\t<title>\r\n\t\t\tMetasploit Pro Social Engineering Web Page\r\n\t\t</title>\r\n\t\t\r\n\t</head>\r\n\t<body>\r\n\t\t\r\n\t</body>\r\n</html>\r\n"
  }


  # Create WebPage
  web_page = Se::WebPage.create(page_data)

  puts "Created web page"

  end
end

build_campaign_with_file_format_component