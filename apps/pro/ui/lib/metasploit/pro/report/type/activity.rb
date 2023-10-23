module Metasploit::Pro::Report::Type::Activity

  LOCATIONS = Metasploit::Pro::Report::Type::Base.locations

  # Dir containing parent template, subtemplates
  def self.report_dir
    File.join(LOCATIONS.pro_report_directory, 'activity', '')
  end

  # Parent jrxml of report
  def self.template_file
    File.join(self.report_dir, 'main.jrxml')
  end

  def self.sections
    {:cover           => 'Cover',
     :project_summary => 'Project Summary',
     :task_details    => 'Task Details'}
  end

  def self.sections_labeled
    labeled = []
    sections.each_pair do |k,v|
      labeled << [v,k]
    end
    labeled
  end

  def self.options
    [:include_task_logs]
  end

  def self.options_labeled
    options.collect do |option|
      [Report::OPTIONS_NAMES[option], option]
    end
  end

  # File types
  def self.formats
    ['pdf', 'html', 'rtf']
  end

  def self.formats_labeled
    formats.collect do |format|
      [format.upcase, format]
    end
  end

  # Pretty name
  def self.name
    'Activity'
  end

  # For help display
  def self.description
    'For each task that has been run in the project, details such as
time run and options are shown.'
  end

  def self.required_data
    [:tasks]
  end

  def self.addresses_included?
    false
  end
end