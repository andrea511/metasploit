module Metasploit::Pro::Report::Type::Custom

  LOCATIONS = Metasploit::Pro::Report::Type::Base.locations

  # Dir containing parent template, subtemplates
  def self.report_dir
    File.join(LOCATIONS.pro_report_custom_resources_directory)
  end

  # Custom reports use custom template selected at generation
  def self.template_file
    ''
  end

  # No sections are assumed for custom reports.
  def self.sections
    {}
  end

  def self.sections_labeled
    labeled = []
    sections.each_pair do |k,v|
      labeled << [v,k]
    end
    labeled
  end

  # No options are assumed for custom reports.
  def self.options
    []
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
    'Custom'
  end

  def self.description
    'User-uploaded custom report template.'
  end

  # No options are assumed for custom reports.
  def self.required_data
    []
  end

  def self.addresses_included?
    true
  end
end