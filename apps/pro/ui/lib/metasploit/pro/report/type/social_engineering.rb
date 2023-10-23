module Metasploit::Pro::Report::Type::SocialEngineering

  LOCATIONS = Metasploit::Pro::Report::Type::Base.locations

  def self.report_dir
    File.join(LOCATIONS.pro_report_directory, 'social_engineering', '')
  end

  def self.template_file
    File.join(self.report_dir, 'ms_se_campaign_detail.jrxml')
  end

  def self.sections
    {:cover                => 'Cover Page',
     :exec_summ            => 'Executive Summary',
     :funnel               => 'Social Engineering Funnel',
     :exploits             => 'Exploits Used',
     :form_subs            => 'Form Submissions',
     :browsers_platforms   => 'Browser/Platform Information',
     :appendix_hosts_hts   => 'Appendices: Hosts Details, Human Targets',
     :appendix_components  => 'Appendix: Campaign Components (Web page/e-mail HTML content)',
     :appendix_remediation => 'Appendix: Remediation Advice'}
  end

  def self.sections_labeled
    labeled = []
    sections.each_pair do |k,v|
      labeled << [v,k]
    end
    labeled
  end

  def self.options
    [:include_page_code, :hide_email_addresses]
  end

  def self.options_labeled
    options.collect do |option|
      [Report::OPTIONS_NAMES[option], option]
    end
  end

  def self.formats
    ['pdf', 'html', 'word', 'rtf']
  end

  def self.formats_labeled
    formats.collect do |format|
      [format.upcase, format]
    end
  end

  def self.name
    'Social Engineering Campaign Details'
  end

  # For help display
  def self.description
    'Details for a selected social engineering campaign.'
  end

  def self.required_data
    [:social_engineering_campaigns]
  end

  def self.addresses_included?
    false
  end
end