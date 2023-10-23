# 
#
# Add some SocialEngineering stuff to the database
# 
# NOTE: this assumes at least one Mdm::User and one Mdm::Workspace already exist

# Convenient shorthand
Se = SocialEngineering

# Sample HTML web page content with form
def phishing_form_html
html =<<-HTML
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
  <p><strong>Fill out the form below to get it:</strong></p>
  <div id="form">
    <label for="username">Username
      <input type="text" name="username" value="" id="username">
    </label>
    <br />
    <label for="password">Password
      <input type="text" name="password" value="" id="password">
    </label>
    <br />
    <br />
    <input type="submit" value="Submit">
  </div>
</body>
</html>
HTML
html
end

# Just something funny to put in as a placeholder
# for real web page content
def goofy_web_page_content
  html =<<-HTML
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>

  <title>Metasploit Pro Social Engineering Web Page</title>
  
</head>
<body>
  <h1> YOU SHALL BE PWNED NOW!</h1>
  <h2>I see you!</h2>
  <img src="http://alabamaformccain.com/wp-content/uploads/2009/11/red-eyed-tree-frog.jpg" />
</body>
</html>
  HTML
  html
end

def build_campaign_with_email_and_web_page
  Se::Campaign.transaction do
    user = Mdm::User.first
    workspace = Mdm::Workspace.first
    campaign = Se::Campaign.create(:user => user, :workspace => workspace, :name => "Lordz of Phishing")

    puts "Created campaign"

    # Create EmailTemplate
    email_template = Se::EmailTemplate.create(:workspace => workspace, 
                                              :name => "Winner's Template", 
                                              :content => "Beginning template\n{{email_content}}\nEnd of template\n")
    
    puts "Created email template"
  

    # Create WebPage
    web_page = Se::WebPage.create(:campaign => campaign, :content => goofy_web_page_content, :path => "winner")

    puts "Created web page"

    # Create HumanTargets
    Se::HumanTarget.create(:first_name => "Michael", :last_name => "Jackson", :email_address => "mj@neverland.com", :workspace => workspace, :user => user)
    Se::HumanTarget.create(:first_name => "Stevie Ray", :last_name => "Vaughn", :email_address => "srv@stevieray.com", :workspace => workspace, :user => user)

    puts "Created human targets"

    # Create TargetList
    target_list = Se::TargetList.create(:name => "iPad Winner Scam", :user => user, :workspace => workspace)

    target_list.human_targets << Se::HumanTarget.all

    puts "Added all HumanTargets to attack list"

    puts "Created email"
    # Create Email
    email = Se::Email.create(:target_list => target_list, :name => "iPad Scam", :campaign => campaign, :content => "Dear Friend,\n You are a winner!", :template => email_template)

  end
end




build_campaign_with_email_and_web_page
