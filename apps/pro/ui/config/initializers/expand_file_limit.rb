platform = Rails.application.platform

if platform.linux32? or platform.linux64?
  # current max
  number_of_files_limit = Process.getrlimit(Process::RLIMIT_NOFILE)[1]

  loop do
    number_of_files_limit *= 2
    number_of_files_soft_limit = number_of_files_limit
    number_of_files_hard_limit = number_of_files_limit

    begin
      Process.setrlimit(Process::RLIMIT_NOFILE, number_of_files_soft_limit, number_of_files_hard_limit)
    rescue Errno::EPERM
      # hit system maximum, NR_OPEN, so stop
      break
    end
  end
end