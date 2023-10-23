class Apps::AppRunsCleaner
  def self.cleanup!
    if Apps::AppRun.table_exists?
      Apps::AppRun.not_done.each(&:abort!)
    end
  end
end
