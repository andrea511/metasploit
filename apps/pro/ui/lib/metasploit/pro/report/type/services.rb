module Metasploit::Pro::Report::Type::Services

  LOCATIONS = Metasploit::Pro::Report::Type::Base.locations

  def self.report_dir
    File.join(LOCATIONS.pro_report_directory, 'services', '')
  end

  def self.template_file
    File.join(self.report_dir, 'msfx_services.jrxml')
  end

  def self.sections
    {:proj_summ      => 'Project Summary',
     :exec_summ      => 'Executive Summary',
     :net_svc_summ   => 'Network Service Summary',
     :net_svc_detail => 'Network Services Table'}
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
    'Services'
  end

  # For help display
  def self.description
    'Details all discovered network services.'
  end

  def self.required_data
    [:hosts]
  end

  def self.addresses_included?
    true
  end
end