
# Add SocialEngineering data required for Campaign reports
#  * with no options, it will:
#    + delete/add a new workspace "SE Testing"
#    + add a new campaign called "Test Campaign 1"
#    + add a Target List "Test Scam 1"
#    + add an Email to the new campaign called "Test Scam"
#    + add a WebPage to the new campaign called "Sample Landing Page 1"
#    + add EmailOpenings for 66% of the recipients
#    + add Visits from 50% of the recipients
#    + add PhishingResults (form submissions) from 25% of the recipients

# Options:
#   --no-openings: does not add EmailOpenings
#   --no-visits: does not add Visits
#   --no-submissions: does not add PhishingResults (form submissions)
#
# Assumptions:
#  * at least one Mdm::User exists


require 'socket'

Se = SocialEngineering

# Sample HTML web page content with form
def webpage_html
  <<-HTML
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
  <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>You're a Winner!</title>
  </head>
  <body>
    <h1>A WINNER - IT'S YOU!</h1>
    <p>We are so happy that you are a winner who wins at things.</p>
    <p>In recognition of just how much you win, we think you should have a prize.</p>  
    <p>Put your <strong>favorite username and password</strong> into the form below 
      and you will be granted <strong>unspeakable riches</strong>:</p>
    <form method='post'>
      <label for="username">Username
        <input type="text" name="username">
      </label>
      <br />
      <label for="password">Password
        <input type="text" name="password">
      </label>
      <br />
      <br />
      <input type="submit" value="Submit">
    </div>
  </body>
  </html>
  HTML
end

def rand_str
  (0..(rand(18)+2)).collect { (rand('z'.ord-'a'.ord)+'a'.ord).chr }.join
end

def phishing_data
  osx_chrome = "{\"headers\": {\"Accept\":\"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\",\"Accept-Charset\":\"ISO-8859-1,utf-8;q=0.7,*;q=0.3\",\"Accept-Encoding\":\"gzip,deflate,sdch\",\"Accept-Language\":\"en-US,en;q=0.8\",\"Cache-Control\":\"max-age=0\",\"Connection\":\"keep-alive\",\"Content-Length\":\"19\",\"Content-Type\":\"application/x-www-form-urlencoded\",\"Cookie\":\"msc=ixhA3IsYQNALyrGu\",\"Host\":\"10.6.255.62:8080\",\"Origin\":\"http://10.6.255.62:8080\",\"Referer\":\"http://10.6.255.62:8080/green91\",\"User-Agent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.75 Safari/537.1\"}, \"body\": {\"username\":\"joe\",\"p1\":\"pas\"}}"
  osx_firefox = "{\"headers\": {\"Accept\":\"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\",\"Accept-Encoding\":\"gzip, deflate\",\"Accept-Language\":\"en-us,en;q=0.5\",\"Connection\":\"keep-alive\",\"Content-Length\":\"23\",\"Content-Type\":\"application/x-www-form-urlencoded\",\"Host\":\"10.6.0.153:8080\",\"Referer\":\"http://10.6.0.153:8080/pink21\",\"User-Agent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20100101 Firefox/15.0\"}, \"body\": {\"name\":\"YYYYY\",\"email\":\"ZZZZZZ\"}}"
  windows7_ie = "{\"headers\": {\"Accept\":\"application/x-ms-application, image/jpeg, application/xaml+xml, image/gif, image/pjpeg, application/x-ms-xbap, */*\",\"Accept-Encoding\":\"gzip, deflate\",\"Accept-Language\":\"en-US\",\"Cache-Control\":\"no-cache\",\"Connection\":\"Keep-Alive\",\"Content-Length\":\"19\",\"Content-Type\":\"application/x-www-form-urlencoded\",\"Host\":\"10.6.0.153:8080\",\"Referer\":\"http://10.6.0.153:8080/green5\",\"User-Agent\":\"Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)\"}, \"body\": {\"name\":\"DIAF\",\"email\":\"yay\"}}"
  ubuntu_firefox = "{\"headers\": {\"Accept\":\"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\",\"Accept-Encoding\":\"gzip, deflate\",\"Accept-Language\":\"en-us,en;q=0.5\",\"Connection\":\"keep-alive\",\"Content-Length\":\"25\",\"Content-Type\":\"application/x-www-form-urlencoded\",\"Host\":\"10.6.0.124:8080\",\"Referer\":\"http://10.6.0.124:8080/purple71\",\"User-Agent\":\"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:11.0) Gecko/20100101 Firefox/11.0\"}, \"body\": {\"name\":\"SuperBob\",\"email\":\"blagh\"}}"
  dataz = [osx_chrome, osx_firefox, windows7_ie, ubuntu_firefox]
  dataz[rand(3)]
end

def phishing_raw_data
  "username=#{rand_str}&p1=#{rand_str}"
end

def build_campaign_with_email_and_web_page
  num = 1
  Se::Campaign.transaction do
    user = Mdm::User.first
    ws_name = 'SE Testing'
    old = Mdm::Workspace.where(:name => ws_name)
    old.destroy_all if old
    workspace = Mdm::Workspace.where(name: ws_name).first_or_create(owner_id: user.id)
    local_ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
    campaign = Se::Campaign.new
    campaign.user = user
    campaign.web_port = 8080
    campaign.web_host = local_ip
    campaign.smtp_auth = 'plain'
    campaign.smtp_batch_size = 50
    campaign.smtp_batch_delay = 1
    campaign.workspace = workspace
    campaign.config_type = 'custom'
    campaign.state = 'finished'
    campaign.name = "Test Campaign #{num}"
    campaign.save!
    puts "Created campaign (#{ws_name})"

    # Create EmailTemplate
    email_template = Se::EmailTemplate.new
    email_template.workspace = workspace
    email_template.name = 'Super Template of Email'
    email_template.user = user
    email_template.content = "Beginning template\n{{email_content}}\nEnd of template\n"
    email_template.save!
    puts "Created email template"
  
    # Create WebPage, will have web server config by default
    web_page = Se::WebPage.new
    web_page.campaign = campaign
    web_page.content = webpage_html
    web_page.path = '/path1'
    web_page.name = "Sample landing page #{num}"
    web_page.attack_type = 'phishing'
    web_page.origin_type = 'custom'
    web_page.phishing_redirect_origin = 'custom_url'
    web_page.phishing_redirect_specified_url = 'www.google.com'
    web_page.save_form_data = true
    web_page.save!
    puts "Created web page"

    # Create TargetList
    #
    # Load in CSV generated by external script.
    # Trying to require and call this to generate the file on the fly
    # ran into oddity with requiring random_data, no idea why:
    csv_file = "/tmp/se_test_data.csv"
    unless File.exist? csv_file
      puts "CSV file doesn't exist! Make it!"
      puts "For now: ruby db/runners/target-list-csv-generator.rb"
      exit 1
    end
    target_list = Se::TargetList.new
    target_list.name = "Test Scam #{num}"
    target_list.user = user
    target_list.workspace = workspace
    target_list.import_file = csv_file
    target_list.save
    puts "Created TargetList"
    
    # Create Email
    email = Se::Email.new
    email.name = 'Test Scam'
    email.email_template_id = email_template.id
    email.attack_type = 'none'
    email.origin_type = 'template'
    email.editor_type = 'plain_text'
    email.user = user
    email.campaign = campaign
    email.target_list = target_list
    email.subject = "Free jewels and moneys! For dollars!"
    email.content = "Dear Friend,\n You are a winner!"
    email.save(:validate => false)
    puts "Created email"

    targets = email.target_list.target_list_targets
    # Assume all emails successfully sent
    targets.each do |ht|
      send = Se::EmailSend.new
      send.email = email
      send.human_target = ht.human_target
      send.save
    end

    unless ARGV.include? '--no-visits'
      # Create visits
      # Assume 50% success
      visit_count = targets.size / 2
      counter = 0
      targets.each do |ht|
        break if counter == visit_count
        ip = "%d.%d.%d.%d" % [rand(256), rand(256), rand(256), rand(256)]
        visit = Se::Visit.new
        visit.human_target = ht.human_target
        visit.email = email
        visit.address = ip
        visit.web_page = web_page
        visit.save
        counter += 1
      end
      puts "Created visits (50% rate of click)"
    end


    unless ARGV.include? '--no-openings'
      # Assume 66% open rate
      open_count = 2 * targets.size / 3
      counter = 0
      targets.each do |ht|
        break if counter == open_count
        ip = "%d.%d.%d.%d" % [rand(256), rand(256), rand(256), rand(256)]
        opening = Se::EmailOpening.new
        opening.human_target = ht.human_target
        opening.email = email
        # Random times, hourly or minute variations from current:
        opening.created_at = [DateTime.now - (rand(61)/1440.0), DateTime.now - (rand(25)/24.0)][rand(2)]
        opening.address = ip
        opening.save
        counter += 1
      end
      puts "Created #{counter} EmailOpenings (66% rate)"
    end

    unless ARGV.include? '--no-submissions'
      # Assume 25% form submission rate
      open_count = targets.size / 4
      counter = 0
      targets.each do |ht|
        break if counter == open_count
        ip = "%d.%d.%d.%d" % [rand(256), rand(256), rand(256), rand(256)]
        result = Se::PhishingResult.new
        result.human_target = ht.human_target
        result.web_page = web_page
        # Random times, hourly or minute variations from current:
        result.created_at = [DateTime.now - (rand(61)/1440.0), DateTime.now - (rand(25)/24.0)][rand(2)]
        result.data = phishing_data
        result.raw_data = phishing_raw_data
        result.address = ip
        result.save
        counter += 1
      end
      puts "Created #{counter} PhishingResults (25% rate)"
    end

    puts "\nAll needed data for campaign reporting have been populated."
    
  end
end


# cd pro/ui && ruby db/runners/target-list-csv-generator.rb && rails runner db/runners/se_reporting_seed_objects.rb
build_campaign_with_email_and_web_page
