module Metasploit::Pro::Report::Type::FISMA

  LOCATIONS = Metasploit::Pro::Report::Type::Base.locations

  # Dir containing parent template, subtemplates
  def self.report_dir
    File.join(LOCATIONS.pro_report_directory, 'fisma', '')
  end

  # Parent jrxml of report
  def self.template_file
    File.join(self.report_dir, 'msfx_fismav1.jrxml')
  end

  def self.sections
    {:exec_summ         => 'Executive Summary',
     :detailed_findings => 'Detailed Findings'}
  end

  def self.sections_labeled
    labeled = []
    sections.each_pair do |k,v|
      labeled << [v,k]
    end
    labeled
  end

  def self.options
    [:mask_credentials]
  end

  def self.options_labeled
    options.collect do |option|
      [Report::OPTIONS_NAMES[option], option]
    end
  end

  # File types
  def self.formats
    ['html', 'pdf', 'rtf', 'xml']
  end

  def self.formats_labeled
    formats.collect do |format|
      [format.upcase, format]
    end
  end

  # Pretty name
  def self.name
    'FISMA Compliance'
  end

  # For help display
  def self.description
    'Summarizes the FISMA compliance of hosts, provides details on any failures.'
  end

  def self.required_data
    [:hosts]
  end

  def self.addresses_included?
    true
  end
end