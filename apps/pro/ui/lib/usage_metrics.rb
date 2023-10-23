module UsageMetrics

  def self.update_config()
    unless self.metrics_enabled? && self.ensure_requires
      metrics_id_file = self.metrics_file
      File.delete(metrics_id_file) if File.exist?(metrics_id_file)
    end
  end


  def self.update(proxy_params = {}, client = Pro::Client.get)
    data = {}
    return data unless self.ensure_requires

    # diagnostics enabled/disabled
    usage_metrics_enabled = self.metrics_enabled?
    usage_metrics_enabled_data = process_boolean_metric_for('enabled', usage_metrics_enabled)
    data.merge!(usage_metrics_enabled_data)

    if usage_metrics_enabled
      n_users = Mdm::User.count
      n_users_data = process_metric_for('n_users', n_users)
      data.merge!(n_users_data)

      n_users_non_admin = Mdm::User.where(admin: false).count
      n_users_non_admin_data = process_metric_for('n_users_non_admin', n_users_non_admin)
      data.merge!(n_users_non_admin_data)

      n_workspaces = Mdm::Workspace.count
      n_workspaces_data = process_metric_for('n_workspaces', n_workspaces)
      data.merge!(n_workspaces_data)

      n_hosts = Mdm::Host.count
      n_hosts_data = process_metric_for('n_hosts', n_hosts)
      data.merge!(n_hosts_data)

      n_services = Mdm::Service.count
      n_services_data = process_metric_for('n_services', n_services)
      data.merge!(n_services_data)

      n_vulns = Mdm::Vuln.count
      n_vulns_data = process_metric_for('n_vulns', n_vulns)
      data.merge!(n_vulns_data)

      n_nx_consoles = Mdm::NexposeConsole.count
      n_nx_consoles_data = process_metric_for('n_nx_consoles', n_nx_consoles)
      data.merge!(n_nx_consoles_data)

      task_stats(data, :auto_exploit, hosts: true, services: true, sessions: true)
      task_stats(data, :sonar_host_discovery)
      task_stats(data, :sonar_import, hosts: true)
      task_stats(data, :file_import, hosts: true, services: true)
      task_stats(data, :single_module_run)
      task_stats(data, :web_app_test, hosts: true, services: true, sessions: true)
      task_stats(data, :quick_pentests, hosts: true, services: true, sessions: true)

      n_logins = Mdm::Event.where(name: 'user_login').count
      n_logins_data = process_metric_for('n_logins', n_logins)
      data.merge!(n_logins_data)

      n_persistent_listeners = Mdm::Listener.count
      n_persistent_listeners_data = process_metric_for('n_persistent_listeners', n_persistent_listeners)
      data.merge!(n_persistent_listeners_data)

      n_vv_runs = Wizards::VulnValidation::Procedure.count
      n_vv_runs_data = process_metric_for('n_vv_runs', n_vv_runs)
      data.merge!(n_vv_runs_data)

      n_vv_matches = MetasploitDataModels::AutomaticExploitation::Match.count
      n_vv_matches_data = process_metric_for('n_vv_matches', n_vv_matches)
      data.merge!(n_vv_matches_data)

      n_vv_validations = Nexpose::Result::Validation.count
      n_vv_validations_data = process_metric_for('n_vv_validations', n_vv_validations)
      data.merge!(n_vv_validations_data)

      n_nx_runs = Nexpose::Data::ImportRun.count
      n_nx_runs_data = process_metric_for('n_nx_runs', n_nx_runs)
      data.merge!(n_nx_runs_data)

      n_nx_new_scans = Nexpose::Data::ImportRun.where(new_scan: true).count
      n_nx_new_scans_data = process_metric_for('n_nx_new_scans', n_nx_new_scans)
      data.merge!(n_nx_new_scans_data)

      n_nx_sites = Nexpose::Data::Site.count
      n_nx_sites_data = process_metric_for('n_nx_sites', n_nx_sites)
      data.merge!(n_nx_sites_data)

      n_nx_assets = Nexpose::Data::Asset.count
      n_nx_assets_data = process_metric_for('n_nx_assets', n_nx_assets)
      data.merge!(n_nx_assets_data)

      n_nx_vulns = Nexpose::Data::VulnerabilityDefinition.count
      n_nx_vulns_data = process_metric_for('n_nx_vulns', n_nx_vulns)
      data.merge!(n_nx_vulns_data)

      n_nx_vuln_instances = Nexpose::Data::VulnerabilityInstance.count
      n_nx_vuln_instances_data = process_metric_for('n_nx_vuln_instances', n_nx_vuln_instances)
      data.merge!(n_nx_vuln_instances_data)

      n_custom_report_templates = ReportCustomResource.templates.count
      n_custom_report_templates_data = process_metric_for('n_custom_report_templates', n_custom_report_templates)
      data.merge!(n_custom_report_templates_data)

      n_custom_report_logos = ReportCustomResource.logos.count
      n_custom_report_logos_data = process_metric_for('n_custom_report_logos', n_custom_report_logos)
      data.merge!(n_custom_report_logos_data)

      add_modules_run_metrics(data)

      add_se_metrics(data)

      add_task_chain_metrics(data)

      add_generated_payloads_metrics(data)

      # Meta-modules are Apps
      Apps::App.all.each do |metamodule|
        n_mm_runs = metamodule.app_runs.count
        n_mm_runs_data = process_metric_for("n_mm_#{metamodule.symbol}_runs",n_mm_runs)
        data.merge!(n_mm_runs_data)
      end
    end

    if data.present?
      ohai_data = Ohai::System.new.all_plugins('platform').slice(*%w(os os_version platform platform_version))
      add_metric_tags(data, ohai_data)

      # obtain metrics key value from disk this key is kept in tmp so the user can remove it easily
      metrics_id_file = self.metrics_file
      if usage_metrics_enabled
        metrics_config = {}
        create_id = true
        if File.exist?(metrics_id_file)
          metrics_config = YAML.load_file metrics_id_file
          # safety check encase a user removes the key without removing the file.
          create_id = false unless metrics_config.nil? || metrics_config['install_id'].nil?
        end
        if create_id
          metrics_config = {}
          metrics_config['install_id'] = SecureRandom.uuid
          File.open(metrics_id_file, 'w') { |f| f.write(metrics_config.to_yaml)}
          ::FileUtils.chmod(0700, metrics_id_file) rescue nil
        end
        data[:tags]['install_id'] = metrics_config['install_id']
      end


      response = client.call("pro.usage_metrics_update", {'usage_metrics_data' => data}, proxy_params)

      if response['status'] == 'success'
        UsageMetric.where(key: 'enabled').first.update_attribute(:value, usage_metrics_enabled) unless usage_metrics_enabled_data.empty?

        if usage_metrics_enabled
          update_local_cumulative_metric_values(data)
        end

        error = nil
      else
        error = response["reason"]
        error = nil if error == ""
      end
    end
    error
  rescue => e
    # ensure metrics cannot cannot kill the update process
    e.message
  end

  def self.process_boolean_metric_for(key, is_true)
    metric = UsageMetric.where(key: key).first
    if metric.present?
      if metric.value =~ /[nf]/ && is_true
        data = {metric.key => "1"}
      elsif metric.value =~ /[t]/ && !is_true
        data = {metric.key => "-1"}
      else
        data = {}
      end
    else
      UsageMetric.create(key: key, value: is_true)
      if is_true
        data = {key => '1'}
      else
        data = {key => '0'}
      end
    end
    data
  end

  def self.process_metric_for(key, count)
    metric = UsageMetric.where(key: key).first
    if metric.present?
      current = metric.value.to_i
      diff = count - current
      if diff == 0
        data = {}
      else
        data = {metric.key => diff.to_s}
      end
    else
      value = count.to_s
      metric = UsageMetric.create(key: key, value: "0")
      data = {metric.key => value}
    end
    data
  end

  def self.add_metric_tags(data, ohai_data)
    data[:tags] = {os: ohai_data['os'], platform: platform_info(ohai_data)}
  end

  def self.update_local_cumulative_metric_values(data)
    data.each do |metric, value|
      next unless metric.to_s.start_with? 'n_'
      metric = UsageMetric.where(key: metric).first
      metric.update_attribute(:value, (metric.value.to_i + value.to_i).to_s)
    end
  end

  private

  def self.ensure_requires()
    begin
      require 'ohai'
      require 'securerandom'
      require 'yaml'
    rescue LoadError => e
      return false
    end
    return true
  end

  def self.add_modules_run_metrics(data)
    module_run_events = Mdm::Event.where(name: 'module_run')
    n_modules_run = module_run_events.count

    n_modules_run_by_type = {}
    n_true_modules_run = 0
    if n_modules_run > 0
      module_run_events.find_each do |event|
        next unless event.info[:module_name] && !event.info[:module_name].match?(/^(auxiliary|exploit)\/pro\/.*/)
        n_true_modules_run += 1
        module_type = event.info[:module_name].split('/', 2).first
        if n_modules_run_by_type[module_type]
          n_modules_run_by_type[module_type] += 1
        else
          n_modules_run_by_type[module_type] = 1
        end
      end
    end

    n_true_modules_run_data = process_metric_for('n_modules_run', n_true_modules_run)
    data.merge!(n_true_modules_run_data)
    n_modules_run_by_type.each_pair do |module_type, run_count|
      n_modules_run_by_type_data = process_metric_for("n_modules_run_#{module_type}", run_count)
      data.merge!(n_modules_run_by_type_data)
    end
  end

  def self.add_se_metrics(data)
    metric_hash = {
        :n_se_with_tracking => 0,
        :n_se_target_visits => 0,
        :n_se_campaigns_with_usb => 0,
        :n_se_campaigns_with_attachment => 0,
        :n_se_attacks => 0
    }

    metric_hash[:n_se_campaigns] = SocialEngineering::Campaign.count
    metric_hash[:n_se_target_lists] = SocialEngineering::TargetList.count
    metric_hash[:n_se_email_templates] = SocialEngineering::EmailTemplate.count
    metric_hash[:n_se_web_templates] = SocialEngineering::WebTemplate.count

    if metric_hash[:n_se_target_lists] > 0
      all_list_sizes = SocialEngineering::TargetListHumanTarget.group(:target_list_id).count
      metric_hash[:n_se_target_list_max] = all_list_sizes.values.sort.last
      metric_hash[:n_se_targets] = all_list_sizes.values.sum
    end

    if metric_hash[:n_se_campaigns] > 0
      SocialEngineering::Campaign::CAMPAIGN_CONFIG_TYPES.each do |config_type|
        type_count = SocialEngineering::Campaign.where(config_type: config_type).count
        metric_hash["n_se_type_#{config_type}"] = type_count if type_count > 0
      end

      SocialEngineering::Campaign.find_each do |campaign|
        if campaign.email_campaign?
          metric_hash[:n_se_with_tracking] += 1 unless campaign.exclude_tracking?
          metric_hash[:n_se_campaigns_with_attachment] += 1 if campaign.emails[0].attack_type != 'none' # ick constant is not a symbol
        end
        metric_hash[:n_se_target_visits] += campaign.visits_with_targets.size
        metric_hash[:n_se_campaigns_with_usb] += 1 if campaign.usb_campaign?
      end

      metric_hash[:n_se_attacks] = SocialEngineering::Email.where(attack_type: 'file').count +
        SocialEngineering::PortableFile.count +
        SocialEngineering::WebPage.where(attack_type: ['exploit', 'file', 'java_signed_applet', 'bap']).count
    end

    metric_hash.each_pair do |key, value|
      n_se_metric_data = process_metric_for(key, value)
      data.merge!(n_se_metric_data)
    end

  end

  def self.add_task_chain_metrics(data)
    n_task_chains = TaskChain.count
    n_task_chains_data = process_metric_for('n_task_chains', n_task_chains)
    data.merge!(n_task_chains_data)

    n_task_chain_schedules = TaskChain.where.not(schedule: nil).count
    n_task_chain_schedules_data = process_metric_for('n_task_chain_schedules', n_task_chain_schedules)
    data.merge!(n_task_chain_schedules_data)

    n_task_chain_steps_total = 0
    n_task_chain_steps_min = n_task_chains > 0 ? 3000 : 0 # arbitrary high min step count
    n_task_chain_steps_max = 0
    TaskChain.find_each do |chain|
      task_count = chain.scheduled_tasks.count
      n_task_chain_steps_total += task_count
      n_task_chain_steps_max = task_count unless task_count < n_task_chain_steps_max
      n_task_chain_steps_min = task_count unless task_count > n_task_chain_steps_min
    end

    if n_task_chains > 0
      ScheduledTask::VALID_TASK_KINDS.each do |curr_kind|
        n_task_chain_kind = ScheduledTask.where(kind: curr_kind).where.not(task_chain_id: nil).count
        n_task_chain_kind_data = process_metric_for("n_task_chain_#{curr_kind}", n_task_chain_kind)
        data.merge!(n_task_chain_kind_data) if n_task_chain_kind > 0
      end
    end

    # add count for chains with schedules to exec

    n_task_chains_data = process_metric_for('n_task_chain_steps_total', n_task_chain_steps_total)
    data.merge!(n_task_chains_data)
    n_task_chains_data = process_metric_for('n_task_chain_steps_min', n_task_chain_steps_min)
    data.merge!(n_task_chains_data)
    n_task_chains_data = process_metric_for('n_task_chain_steps_max', n_task_chain_steps_max)
    data.merge!(n_task_chains_data)
  end

  def self.add_generated_payloads_metrics(data)
    # this is interesting as the payloads "auto" destroy so new events need to be created
    generated_payloads_events = Mdm::Event.where(name: 'generate_payload')
    n_generated_payloads = generated_payloads_events.count
    n_generated_payloads_data = process_metric_for('n_generated_payloads', n_generated_payloads)
    data.merge!(n_generated_payloads_data)

    n_dynamic_payloads = 0
    if n_generated_payloads > 0
      generated_payloads_events.find_each do |event|
        n_dynamic_payloads += 1 if event.info[:dynamic]
      end
    end
    n_generated_payloads_dynamic_data = process_metric_for('n_generated_payloads_dynamic', n_dynamic_payloads)
    data.merge!(n_generated_payloads_dynamic_data)
  end

  def self.metrics_enabled?
    Mdm::Profile.find_by(active: true).settings['usage_metrics_user_data']
  end

  def self.metrics_file
    Rails.root.parent.join('ui', 'tmp', 'metrics_identifier.yml')
  end

  def self.task_stats(data, metric, hosts: false, services:false, sessions: false )
    metric_to_module = {
      :auto_exploit => 'pro/exploit',
      :sonar_host_discovery => 'pro/sonar/host_discovery',
      :sonar_import =>'pro/sonar/import',
      :file_import => 'pro/import',
      :single_module_run => 'pro/single',
      :web_app_test => 'pro/wizard/web_app_test',
      :quick_pentests => 'pro/wizard/quick_pentest'
    }

    module_name = metric_to_module[metric]

    n_task = Mdm::Task.where(module: module_name).count
    n_task_data = process_metric_for("n_#{metric}", n_task)
    data.merge!(n_task_data)

    host_count = 0
    service_count = 0
    session_count = 0
    Mdm::Task.where(module: module_name).find_each do |task|
      host_count += task.hosts.count
      service_count += task.services.count
      session_count += task.sessions.count
    end

    if hosts
      n_hosts_data = process_metric_for("n_#{metric}_hosts", host_count)
      data.merge!(n_hosts_data)
    end

    if services
      n_services_data = process_metric_for("n_#{metric}_services", service_count)
      data.merge!(n_services_data)
    end

    if sessions
      n_sessions_data = process_metric_for("n_#{metric}_sessions", session_count)
      data.merge!(n_sessions_data)
    end
  end

  def self.platform_info(ohai_data)
    (ohai_data['platform'] || ohai_data['lsb']&.[]('id') || ohai_data['os']) +
      (ohai_data['platform_version'] || ohai_data['lsb']&.[]('release') || ohai_data['os_version'])
  end
end
