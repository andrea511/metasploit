module Metasploit::Pro::Report::Type::MM_Auth

  LOCATIONS = Metasploit::Pro::Report::Type::Base.locations

  def self.report_dir
    File.join(LOCATIONS.pro_report_directory, 'credential_metamodules', '')
  end

  def self.template_file
    File.join(self.report_dir, 'main.jrxml')
  end

  def self.sections
    {:cover                  => 'Cover Page',
     :proj_summ              => 'Project Summary',
     :findings_summ          => 'Findings Summary',
     :svcs_hosts_summ_charts => 'Authenticated Services and Hosts Summary Charts',
     :svcs_hosts_details     => 'Authenticated Services and Hosts Details',
     :appendix_options       => 'Appendix: Report Options Selected'}
  end

  def self.sections_labeled
    labeled = []
    sections.each_pair do |k,v|
      labeled << [v,k]
    end
    labeled
  end

  def self.options
    [:mask_credentials, :include_charts]
  end

  def self.options_labeled
    options.collect do |option|
      [Report::OPTIONS_NAMES[option], option]
    end
  end

  def self.formats
    ['pdf', 'html', 'rtf']
  end

  def self.formats_labeled
    formats.collect do |format|
      [format.upcase, format]
    end
  end

  def self.name
    'Credential MetaModule' # Name per MM set in jrxml from apps.name
  end

  # For help display
  def self.description
    'Findings from a Credential-related MetaModule run'
  end

  def self.required_data
    [:hosts]
  end

  def self.addresses_included?
    true
  end
end