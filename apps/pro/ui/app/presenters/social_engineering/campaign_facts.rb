class SocialEngineering::CampaignFacts < Struct.new(:campaign)

  # ---- raw count attributes ----
  def emails_sent_count
    campaign.emails.to_a.sum do |email|
      email.email_sends.where(sent: true).count
    end
  end

  def emails_opened_count
    @emails_opened_count ||= OpenedEmailsFinder.new(campaign).find.length
  end

  def email_links_clicked
    @links_clicked ||= ClickedLinkTargetsFinder.new(campaign).find.length
  end

  def raw_phishing_results
    @raw_phishing_results ||= SubmittedFormsFinder.new(campaign).find.sort{|x,y| x.created_at <=> y.created_at}
  end

  # Count of unique HumanTargets that submitted the form in a phishing campaign
  def submit_form_count
    @submit_form_count ||= lambda{
      with_dupes = raw_phishing_results.select{ |pr| pr.human_target_id.present? }
      with_dupes.collect(&:human_target_id).uniq.size
    }.call
  end

  # ---- percentage attributes ----

  def email_open_percentage
    return 0 unless emails_sent_count > 0
    raw = ( emails_opened_count.to_f / emails_sent_count.to_f ) * 100
    raw.truncate(1)
  end

  def email_click_percentage
    return 0 unless emails_sent_count > 0
    raw = ( email_links_clicked.to_f / emails_sent_count.to_f ) * 100
    raw.truncate(1)
  end

  def submit_form_percentage
    return 0 unless emails_sent_count > 0
    raw = ( submit_form_count.to_f / emails_sent_count.to_f ) * 100
    raw.truncate(1)
  end

  # ---- show/hide attribute circles ----
  def emails_sent_visible?
    campaign.email_campaign?
  end

  def emails_opened_visible?
    campaign.email_campaign? && emails_sent_count > 0 && (!campaign.exclude_tracking?)
  end

  def links_clicked_visible?
    campaign.email_campaign? && campaign.web_campaign? && 
      (emails_with_links_count > 0 || SocialEngineering::EmailOpening.in_campaign(campaign).count > 0)
  end

  def forms_started_visible?
    campaign.web_campaign? && phishing_pages_count > 0
  end

  def forms_submitted_visible?
    campaign.web_campaign? && phishing_pages_count > 0
  end

  def prone_to_bap_visible?
    false
  end

  def sessions_count
    Mdm::Session.where(:campaign_id => campaign.id).count
  end

  def sessions_visible?
    campaign.portable_files.count > 0 ||
      attack_pages_count > 0 ||
      attack_emails_count > 0
  end

  def to_hash
    {
      emails_sent: {
        visible: emails_sent_visible?,
        count: emails_sent_count,
        percentage: 100
      },
      emails_opened: {
        visible: emails_opened_visible?,
        count: emails_opened_count,
        percentage: email_open_percentage
      },
      links_clicked: {
        visible: links_clicked_visible?,
        count: email_links_clicked,
        percentage: email_click_percentage
      },
      forms_started: {
        visible: false,
        count: 0
      },
      prone_to_bap: {
        visible: prone_to_bap_visible?,
        count:0
      },
      forms_submitted: {
        visible: forms_submitted_visible?,
        count: submit_form_count,
        percentage: submit_form_percentage
      },
      sessions_opened: {
        visible: sessions_visible?,
        count: sessions_count
      }
    }
  end

  private
    # @return (Integer) number of emails in the campaign that require handlers
    def attack_emails_count
      @attack_emails_count ||=
        campaign.emails.where("attack_type != (?)", 'none').count
    end

    def attack_pages_count
      @attack_pages_count ||= campaign.web_pages.where(
        "attack_type NOT IN (?)", ['none', 'phishing']
      ).count
    end

    def phishing_pages_count
      @phishing_pages_count ||= campaign.web_pages.where(:attack_type => 'phishing').count
    end

    def emails_with_links_count
      @emails_with_links_count ||= campaign.emails.where(
        'content ILIKE (?) OR content ILIKE (?)', '%campaign_web_link%', '%campaign_href%').count
    end

    def processed_phishing_results
      
    end
end
