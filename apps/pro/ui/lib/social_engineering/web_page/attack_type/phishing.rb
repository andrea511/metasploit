module SocialEngineering::WebPage::AttackType::Phishing
  extend ActiveSupport::Concern

  #
  # CONSTANTS
  #

  DEFAULT_PHISHING_CONTENT = <<-eos
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Metasploit Pro Social Engineering Web Page</title>
</head>
<body>
  <h1>if this were a real phish, we would be stealing your credentials.</h1>
  <form method="POST">
    Username <input type="text" name="uname"><br>
    Password <input type="password" name="pwd"><br>
    Social Security Number  <input type="password" name="ssn"><br>
    Credit Card Number  <input type="text" name="cc"><br>
    <input type="submit" value="Submit">
  </form>
</body>
</html>
eos

  DEFAULT_REDIRECT_CONTENT = <<-eos
<!doctype html>
<html>
<head>
  <title>Phishing Awareness Training</title>
  <meta charset="UTF-8">
  <style type="text/css">
    #columns {
        width: 900px;
    }

    #columns .column {
        position: relative;
        width: 46%;
    height: 100%;
        padding: 1%;
    }

    #columns .left {
        float: left;
    }

    #columns .middle {
        float: middle;
    }

    #columns .right {
        float: right;
    }

    body {
      margin: 0px;
      padding: 0px;
      font-family: 'Trebuchet MS', verdana;
    }
  </style>
</head>

<body>
  <p><img src="https://www.rapid7.com/includes/img/logo-black.png" alt="Rapid7" /></p>

  <h1>WARNING: Your Machine Could Have Been Hacked!</h1>
  <div id="columns">
    <div class="left column">
      <h3>What Just Happened?</h3>

      <p>The e-mail you just clicked on was a simulated phishing e-mail, the same kind of
      e-mail that hackers use to steal data. <b>If this had been a real attack, your
      computer could have been hacked, simply by visiting a webpage.</b> Rest assured
      that this time, no harm was done. To keep you and your data safe, your organization
      is periodically sending out these phishing emails to educate users.</p>

      <h3>What is Phishing?</h3>

      <p>Phishing refers to sending an e-mail which tricks someone into clicking on a
      link or opening an attachment. The end goal of phishing is to steal valuable
      information, such as usernames and passwords.</p>

      <h3>Why Should You Care?</h3>

      <p>Clicking on links in phishing e-mails, or filling in confidential information on
      malicious websites, can put your data at risk - not only the company's but also
      your personal data. Through phishing emails, attackers can gain access to
      confidential company data, steal money from your bank accounts, and steal your
      identity.</p>

      <h3>What's Safe To Do, And What Isn't?</h3>

      <p>There is very little risk in simply opening e-mails. In almost all cases,
      opening an e-mail will not result in compromise.</p>

      <p>The risk is in clicking on links or opening attachments. Attackers can e-mail
      you infected attachments which install malicious software, or "malware" for short.
      Clicking on a link can take you to a website which steals login or other valuable
      information. The website could also install malware on your machine without your
      knowledge.</p>
    </div>

    <div class="right column">
      <h3>How Can You Spot a Phishing E-Mail?</h3>

      <p>Phishing emails can be hard to recognize, and every phishing e-mail is
      different. Here are some telltale signs:</p>

      <ul>
        <li><b>Bad spelling and grammar:</b> Simple phishing emails are often poorly
        written. If the content of the e-mail doesn't line up with what you'd expect from
        the sender, beware!</li>

        <li><b>Deceptive links:</b> Move your mouse over any of the links in the e-mail,
        without clicking. You should see the address where the link will take you.
        <img src=
        "data:image/jpg;base64,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" />
         If it's an e-mail from your bank, but the link doesn't display your bank's
        website, don't click.</li>

        <li><b>Sense of urgency:</b> Is the e-mail claiming that you were charged an
        extraordinary amount on your cell phone bill, or telling you your e-mail account
        has been suspended? Be careful - somebody may want to push your buttons so you
        click on a malicious link. When in doubt, pick up the phone.</li>

        <li><b>No name in e-mail:</b> Is an e-mail starting with <i>Dear Customer</i> but
        not incuding your real name? Chances are the fraudster doesn't even know who this
        e-mail account belongs to. Don't click.</li>
      </ul>If you receive any "phishy" emails, please forward them to your IT department,
      asking them to analyze the e-mail and contact the authorities.

      <h3>Why Are We Sending Simulated Phishing Emails?</h3>

      <p>These tests are designed to help you. The lessons learned apply not only to work
      but to your personal life. Be sure to share with your family and friends. If you
      have any more questions on what phishing attacks are, or on security in general,
      feel free to contact <a href="mailto:helpdesk">your IT security team</a> for more
      information.</p>
    </div>
  </div>
</body>
</html>
eos

  PHISHING_LANDING_PAGE_DEFAULT_NAME = 'Landing Page'
  PHISHING_REDIRECT_ORIGINS = ['custom_url', 'campaign_web_page', 'phishing_wizard_redirect_page']
  PHISHING_REDIRECT_PAGE_DEFAULT_NAME = 'Redirect Page'

  included do
    extend MetasploitDataModels::SerializedPrefs

    #
    # Callbacks
    #

    before_save :ensure_phishing_redirect_url_includes_protocol

    #
    # Associations
    #

    has_many :phishing_results, :class_name => 'SocialEngineering::PhishingResult'

    #
    # Serialized Preferences
    #

    serialized_prefs_attr_accessor :phishing_redirect_specified_url
    serialized_prefs_attr_accessor :phishing_redirect_web_page_id

    #
    # Validations
    #

    # if this is a phishing attack, let's ensure we have a default page set for redirect
    validates :phishing_redirect_origin,
              :inclusion => {
                  :allow_nil => true,
                  :in => PHISHING_REDIRECT_ORIGINS
              }
    validate  :phishing_redirect_exists_if_necessary
  end

  #
  # Instance Methods - sorted by name
  #

  def phishing_attack?
    attack_type == 'phishing'
  end

  # since i broke the old interface, i'll keep this in here for now
  # for backwards compatibility :)
  # @deprecated
  def phishing_redirect
    warn '"phishing_redirect" is deprecated. use "phishing_redirect_url" instead!'
    phishing_redirect_url
  end

  # @return [String] containing the URL to redirect to
  #   returns nil if the redirect page has been deleted or was never created
  def phishing_redirect_url
    return nil unless self.phishing_attack?
    case self.phishing_redirect_origin
      when 'custom_url'
        self.phishing_redirect_specified_url
      when 'campaign_web_page'
        redirect_page = SocialEngineering::WebPage.find_by_id(phishing_redirect_web_page_id)

        if redirect_page.nil?
          nil
        else
          redirect_page.url
        end
      when 'phishing_wizard_redirect_page'
        redirect_name = SocialEngineering::WebPage::PHISHING_REDIRECT_PAGE_DEFAULT_NAME
        redirect_page = SocialEngineering::WebPage.where(:name => redirect_name, :campaign_id => campaign.id).first

        if redirect_page.nil?
          nil
        else
          redirect_page.url
        end
    end
  end

  private

  def ensure_phishing_redirect_url_includes_protocol
    if self.phishing_attack?
      if self.phishing_redirect_origin == 'custom_url'
        uri = ::URI.parse(self.phishing_redirect_specified_url) rescue nil
        if uri.present? && uri.scheme.nil?
          self.phishing_redirect_specified_url = "http://#{self.phishing_redirect_specified_url}"
        end
      end
    end
  end

  def phishing_redirect_exists_if_necessary
    if self.phishing_attack?
      case self.phishing_redirect_origin
        when 'custom_url'
          unless self.phishing_redirect_specified_url.present?
            errors.add(:phishing_redirect_specified_url, "must be specified")
          end
        when 'campaign_web_page'
          if self.phishing_redirect_web_page_id.blank?
            errors.add(:phishing_redirect_web_page_id, "must be present")
          elsif SocialEngineering::WebPage.find_by_id(self.phishing_redirect_web_page_id).nil?
            errors.add(:phishing_redirect_web_page_id, "must specify a valid Web Page")
          end
      end
    end
  end
end