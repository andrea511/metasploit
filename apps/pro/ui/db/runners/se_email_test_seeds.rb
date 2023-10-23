Se = SocialEngineering

user                = `whoami`.chomp
hostname            = `hostname`.chomp
target_list_name    = "Local Send Test"
local_email_address = "#{user}@#{hostname}"

workspace = Mdm::Workspace.first
user = Mdm::User.first




Se::TargetList.transaction do
  target_list = Se::TargetList.create(:name => target_list_name, :workspace => workspace, :user => user)

  target_list.human_targets << Se::HumanTarget.create(:first_name => user, 
                                                      :last_name => "McGoo", 
                                                      :email_address => local_email_address, 
                                                      :workspace => workspace, 
                                                      :user => user)
  target_list.save!

  puts "Saved attack list called '#{target_list_name}'"
end


Se::Email.transaction do
  campaign = Se::Campaign.last
  campaign.update(
                        :smtp_host => "localhost",
                        :smtp_port => 25,
                        :smtp_username => "",
                        :smtp_password => ""
  )
  email_template = Se::EmailTemplate.last

  email = Se::Email.new(:campaign => campaign,
                        :name => "Local test email",
                        :content =>"Dear {{first_name}} - we can now send email!",
                        :template => email_template,
                        :user => user, 
                        :subject => "Local test like a baws",
                        :from_name => "Lord Phish",
                        :from_address => "lord_phish@foobar.com",
                        :target_list => Se::TargetList.last,

                       )
  email.save!
  puts "Created a test email"
end
