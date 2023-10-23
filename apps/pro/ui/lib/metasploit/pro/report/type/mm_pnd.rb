module Metasploit::Pro::Report::Type::MM_PND

  LOCATIONS = Metasploit::Pro::Report::Type::Base.locations

  def self.report_dir
    File.join(LOCATIONS.pro_report_directory, 'passive_network_discovery', '')
  end

  def self.template_file
    File.join(self.report_dir, 'main.jrxml')
  end

  def self.sections
    {:cover            => 'Cover Page',
     :proj_summ        => 'Project Summary',
     :findings_summ    => 'Findings Summary',
     :host_svc_dist    => 'Host and Service Distribution',
     :detail_findings  => 'Detailed Findings',
     :appendix_options => 'Appendix: Report Options Selected'}
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
    'Passive Network Discovery'
  end

  # For help display
  def self.description
    'Findings from a Passive Network Discovery MetaModule run.'
  end

  def self.required_data
    []
  end

  def self.addresses_included?
    true
  end
end