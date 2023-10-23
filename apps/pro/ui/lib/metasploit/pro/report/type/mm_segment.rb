module Metasploit::Pro::Report::Type::MM_Segment

  LOCATIONS = Metasploit::Pro::Report::Type::Base.locations

  def self.report_dir
    File.join(LOCATIONS.pro_report_directory, 'segmentation_firewall', '')
  end

  def self.template_file
    File.join(self.report_dir, 'main.jrxml')
  end

  def self.sections
    {:cover              => 'Cover Page',
     :proj_summ          => 'Project Summary',
     :egress_summ        => 'Egress Summary',
     :port_state_dist    => 'Port State Distribution',
     :crit_nonfilt_ports => 'Critical Non-Filtered Ports',
     :reg_nonfilt_ports  => 'Registered Non-Filtered Ports',
     :appendix_res       => 'Appendix: Resources',
     :appendix_options   => 'Appendix: Report Generation Options'}
  end

  def self.sections_labeled
    labeled = []
    sections.each_pair do |k,v|
      labeled << [v,k]
    end
    labeled
  end

  def self.options
    []
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
    'Segmentation and Firewall Testing'
  end

  # For help display
  def self.description
    'Findings from a Segmentation and Firewall Testing MetaModule run.'
  end

  def self.required_data
    []
  end

  # Host objects not implicated in this format
  def self.addresses_included?
    false
  end
end