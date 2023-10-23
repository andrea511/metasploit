module Metasploit::Pro::Report::Type::Audit

  LOCATIONS = Metasploit::Pro::Report::Type::Base.locations

  # Dir containing parent template, subtemplates
  def self.report_dir
    File.join(LOCATIONS.pro_report_directory, 'audit', '')
  end

  # Parent jrxml of report
  def self.template_file
    File.join(self.report_dir, 'msfxv3.jrxml')
  end

  def self.sections
    {:exec_summ    => 'Executive Summary and Tags',
     :compr_hosts  => 'Compromised Hosts',
     :compr_creds  => 'Compromised Credentials',
     :disc_oses    => 'Discovered OSes',
     :disc_hosts   => 'Discovered Hosts',
     :host_details => 'Host Details',
     :disc_svcs    => 'Discovered Services',
     :web_sites    => 'Web Sites'}
  end

  def self.sections_labeled
    labeled = []
    sections.each_pair do |k,v|
      labeled << [v,k]
    end
    labeled
  end

  def self.options
    [:mask_credentials, :include_sessions, :include_charts]
  end

  def self.options_labeled
    options.collect do |option|
      [Report::OPTIONS_NAMES[option], option]
    end
  end

  # File types
  def self.formats
    ['pdf', 'html', 'word', 'rtf']
  end

  def self.formats_labeled
    formats.collect do |format|
      [format.upcase, format]
    end
  end

  # Pretty name
  def self.name
    'Audit'
  end

  # For help display
  def self.description
    'Combines high-level project data into a single, unified view.'
  end

  def self.required_data
    [:hosts]
  end

  def self.addresses_included?
    true
  end
end