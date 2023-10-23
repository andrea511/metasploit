module Mdm::Task::Information
	def collection?
		description =~ /Collect/
  end

  def discovery?
    description =~ /Discovering|Nexpose/
  end

  def penetration?
    description =~ /Exploit|Launching/
  end

  def active_sessions?
    if Mdm::TaskSession.where(task: self).count > 0
      Mdm::Session.alive.where(id: Mdm::TaskSession.where(task: self).pluck(:id)).count > 0
    else
      false
    end
  end

  def report?
    description =~ /Mdm::Report/
  end

  def webaudit?
    self.module == "pro/webaudit"
  end

  def webscan?
    self.module == "pro/webscan"
  end

  def quick_web_app_scan?
    self.module == "pro/wizard/web_app_test"
  end
end
