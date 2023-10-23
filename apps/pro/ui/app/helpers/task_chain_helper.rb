module TaskChainHelper

  # Generate select list for a list of task types
  def scheduled_task_select_options
    default_pair = ["Add Task", ""]
    options = [
      ["Scan", "scan"],
      ["Import", "import"],
      ["Nexpose", "nexpose"],
      ["Bruteforce", "bruteforce"],
      ["Exploit", "exploit"],
      ["Module run", "module_run"],
      ["Collect evidence", "collect"],
      ["Cleanup", "cleanup"],
      ["Report", "report"],
      ["Web Scan", "webscan"],
    ]
    options_for_select(options.unshift(default_pair))
  end

  def scheduler_frequency_options
    options_for_select %w{once hourly daily weekly}
  end

  def scheduler_monthly_day_options
    options = (1..31).collect do |i|
      [ i.ordinalize, i ]
    end

    options_for_select(options)
  end

  def scheduler_monthly_interval_options
    options_for_select %w{first second third fourth last day}
  end

  def scheduler_monthly_day_of_week_options
    options_for_select %W{Sunday Monday Tuesday Wednesday Thursday Friday day}
  end

  def scheduler_hourly_minute_options
    options_for_select 1..59
  end

  def printable_date(date)
    return 'n/a' if date.nil?
    date.localtime.strftime('%B %-e, %Y at %-l:%M %p')
  end
end
