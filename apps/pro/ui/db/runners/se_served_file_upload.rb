
Se = SocialEngineering


def build_campaign_with_file_component
  Se::Campaign.transaction do
  user = Mdm::User.first
  workspace = Mdm::Workspace.first
  campaign = Se::Campaign.create(:user => user, :workspace => workspace, :name => "Uploaded File Serve")

  puts "Created campaign"
  puts "#{campaign.inspect}"
  

  page_data = {
    "name"        => "Fileserve1",
    "path"        => "file1",
    "attack_type" => "file",
    "file_generation_type" => "user_supplied",
    "origin_type" => "custom",
    "campaign_id" => campaign.id,
    "user_supplied_file" => 'file.exe'
  }


  # Create WebPage
  web_page = Se::WebPage.create(page_data)

  puts "Created web page"

  file_content = "Hello World!"
  qfile = Rex::Quickfile.new("hello.txt", binmode: true)
  qfile.write(file_content)
  f = SocialEngineering::CampaignFile.new
  f.attachment = qfile
  f.attachable = web_page
  f.attachment.file.content_type = 'text/plain'
  f.save
  qfile.unlink

  puts "Created Campaign File"

  end
end

build_campaign_with_file_component