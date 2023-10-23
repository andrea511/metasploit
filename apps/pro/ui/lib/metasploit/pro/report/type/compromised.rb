module Metasploit::Pro::Report::Type::Compromised

  LOCATIONS = Metasploit::Pro::Report::Type::Base.locations

  def self.report_dir
    File.join(LOCATIONS.pro_report_directory, 'compromised_hosts', '')
  end

  def self.template_file
    File.join(self.report_dir, 'msfx_compromised_hosts.jrxml')
  end

  def self.sections
    {:proj_summ      => 'Project Summary',
     :exec_summ      => 'Executive Summary',
     :compr_summ     => 'Compromised Summary',
     :compr_hosts    => 'Compromised Hosts',
     :vulns_exploits => 'Vulnerabilities and Exploits'}
  end

  def self.sections_labeled
    labeled = []
    sections.each_pair do |k,v|
      labeled << [v,k]
    end
    labeled
  end

  def self.options
    [:include_charts]
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
    'Compromised and Vulnerable Hosts'
  end

  # For help display
  def self.description
    'Details all hosts on which Metasploit opened a session, successfully ran a module, or recorded a vulnerability.'
  end

  def self.required_data
    [:hosts]
  end

  def self.addresses_included?
    true
  end
end