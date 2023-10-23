module Metasploit::Pro::Report::Type::PCI

  LOCATIONS = Metasploit::Pro::Report::Type::Base.locations

  # Dir containing parent template, subtemplates
  def self.report_dir
    File.join(LOCATIONS.pro_report_directory, 'pci', '')
  end

  # Parent jrxml of report
  def self.template_file
    File.join(self.report_dir, 'main.jrxml')
  end

  def self.sections
    {:exec_summ         => 'Executive Summary',
     :req_status_summ   => 'Requirements Status Summary',
     :host_status_summ  => 'Host Status Summary',
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
    'PCI Compliance'
  end

  # For help display
  def self.description
    'Summarizes the PCI compliance of hosts, provides details on any failures.'
  end

  def self.required_data
    [:hosts]
  end

  def self.addresses_included?
    true
  end
end