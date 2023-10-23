# The Wizards::QuickWebAppScan::Procedure strings together some tasks:
# 1. Create workspace (done before module run)
# 2. Run a web scan / import web hosts
# 3. [Optional] Run a web audit task
# 4. [Optional] Run a web sploit task
# 5. [Optional] Generate a Web App Assessment Report
class Wizards::QuickWebAppScan::Procedure < Wizards::BaseProcedure
  # todo kill with fire, see VulnValidation::Procedure
  # Run our state transitions OUTSIDE of transaction block
  include AfterCommitQueue

  # Lets make this public so that we don't need to call .send in
  #  our after_transition callbacks.
  # Allows us to run logic in an after_transition callback that
  #  escapes the implicit transaction involved in running transition
  #  events.
  public :run_after_commit

  #
  # State Machine
  #
  state_machine :state, :initial => :ready do
    after_transition any => :scanning do |wizard, transition|
      wizard.run_after_commit do
        wizard.commander.run_module 'auxiliary/pro/webscan',
                                    wizard.config_hash[:web_scan_task]
      end
    end

    after_transition any => :importing do |wizard, transition|
      wizard.run_after_commit do
        wizard.commander.run_module 'auxiliary/pro/import',
                                    wizard.config_hash[:import_task]
      end
    end

    after_transition any => :finding_vulns do |wizard, transition|
      wizard.run_after_commit do
        wizard.update_audit_targets!
        wizard.commander.run_module 'auxiliary/pro/webaudit',
                                     wizard.config_hash[:web_audit_task]
      end
    end

    after_transition any => :exploiting do |wizard, transition|
      wizard.run_after_commit do
        wizard.update_sploit_vulns!
        wizard.commander.run_module 'auxiliary/pro/websploit',
                                    wizard.config_hash[:web_sploit_task]
      end
    end

    after_transition any => :generating_report do |wizard, transition|
      wizard.run_after_commit do
        report = Report.find(wizard.config_hash[:report_id])
        report.generate_delayed
      end
    end

    # build a finite mapping of state -> state for the next! event
    event :next do
      transition :ready         => :scanning,          :if => :should_scan?
      transition :ready         => :importing,         :if => :should_import?
      transition :scanning      => :finished,          :if => :no_sites_found?
      transition :scanning      => :finding_vulns,     :if => :should_find_vulns?
      transition :scanning      => :generating_report, :if => :should_generate_report?
      transition :scanning      => :finished
      transition :importing     => :finding_vulns,     :if => :should_find_vulns?
      transition :importing     => :generating_report, :if => :should_generate_report?
      transition :importing     => :finished
      transition :finding_vulns => :exploiting,        :if => :vulns_found_and_should_exploit?
      transition :finding_vulns => :generating_report, :if => :should_generate_report?
      transition :finding_vulns => :finished
      transition :exploiting    => :generating_report, :if => :should_generate_report?
      transition :exploiting    => :finished
      transition :generating_report => :finished
    end

    event :error_occurred do |error_str|
      transition any => :error
    end
  end

  # modifies the web_sploit_task's VULNERABILITIES key so that we have
  #   something to exploit.
  def update_sploit_vulns!
    if config_hash[:web_sploit_task].present?
      vuln_string = gather_web_vulns.map(&:id).join("\n")
      config_hash[:web_sploit_task]["DS_VULNERABILITIES"] = vuln_string
    end
  end


  # modifies wizard.config_hash[:web_audit_task] to point to some valid URLs
  # @param [Array<String>] web_urls list of URLs to scan
  def update_audit_targets!
    if config_hash[:web_audit_task].present?
      config_hash[:web_audit_task]["DS_URLS"] = gather_web_urls.join("\n")
    end
  end

  # @return [Array] of URLs in the current workspace to hit
  def gather_web_urls
    urls = workspace.web_unique_forms.map do |form|
      form.web_site.to_url(true) + form.path
    end
    urls.uniq.sort
  end

  # @return [Array] of Mdm::WebVuln objects to hit
  def gather_web_vulns
    site_ids = workspace.web_unique_forms.collect(&:web_site_id).uniq
    Mdm::WebVuln.where("web_site_id IN (?)", site_ids).to_a
  end

  private

  def vulns_found_and_should_exploit?
    !no_vulns_found? and should_exploit?
  end

  # @return [Boolean] the presence of Mdm::WebVulns in the current workspace
  def no_vulns_found?
    gather_web_vulns.empty?
  end

  # @return [Boolean] presence of Mdm::WebSites in the current workspace
  def no_sites_found?
    workspace.web_unique_forms.empty?
  end

  # Returns true if the user wants to run the web_audit task
  # @return [Boolean]
  def should_find_vulns?
    config_hash[:web_audit_task].present?
  end

  # Returns true if the user wants to run the web_sploit task
  # @return [Boolean]
  def should_exploit?
    config_hash[:web_sploit_task].present?
  end

  # Returns true if the user wants to run a Report on the workspace
  # @return [Boolean]
  def should_generate_report?
    config_hash[:report_id].present?
  end

  # Returns true if the user wants to run a web_scan task
  # @return [Boolean]
  def should_scan?
    config_hash[:scan_type].to_s == "scan_now"
  end

  # Returns true if the user wants to import data instead of scanning
  # @return [Boolean]
  def should_import?
    config_hash[:scan_type].to_s == "import"
  end
end
