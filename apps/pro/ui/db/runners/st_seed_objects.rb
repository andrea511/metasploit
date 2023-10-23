# 
#
# Add some Scheduled Tasks (chains and tasks) stuff to the database
# 
# NOTE: this assumes at least one Mdm::User and one Mdm::Workspace already exist

require 'ice_cube'

print "Grabbing user and workspace info..."
user = Mdm::User.first
workspace = Mdm::Workspace.first
puts "Done"

print "Building IceCube object..."
schedule = IceCube::Schedule.new
schedule.add_recurrence_rule IceCube::Rule.hourly
#schedule.each_occurrence { |t| puts t }
puts "Done"

discover_config = {
    'RHOSTS' => ["10.6.203.0/24"],
    'workspace' => workspace.name,
    'DS_SNMP_SCAN' => false
}

exploit_config = {
    "workspace" => workspace.name,
    "DS_WHITELIST_HOSTS" => "10.6.203.0/24",
    "DS_MinimumRank" => "great",
    "DS_EXPLOIT_SPEED" => 5,
    "DS_EXPLOIT_TIMEOUT" => 2,
    "DS_LimitSessions" => true,
    "DS_MATCH_VULNS" => true,
    "DS_MATCH_PORTS" => true,
}

bruteforce_config = {
    "workspace" => workspace.name,
    "DS_WHITELIST_HOSTS" => "10.6.203.0/24",
    "DS_BRUTEFORCE_SCOPE" => "defaults",
    "DS_BRUTEFORCE_SERVICES" => "SSH HTTP",
    "DS_BRUTEFORCE_SPEED" => "TURBO",
    "DS_INCLUDE_KNOWN" => false,
    "DS_BRUTEFORCE_GETSESSION" => true,
}

report_config = {
    "workspace" => workspace.name,
    "DS_WHITELIST_HOSTS" => "10.6.203.0/24",
    "DS_MaskPasswords" => true,
    "DS_IncludeTaskLog" => false,
    "DS_JasperDisplaySession" => true,
    "DS_DisplayCharts" => true,
    "DS_LootExcludeScreenshots" => true,
    "DS_LootExcludePasswords" => true,
    "DS_JasperTemplate" => false,
    "DS_REPORT_TYPE" => 'PDF', 
    "DS_UseJasper" => true,
    "DS_JasperProductName" => 'Scheduled Task Test Report',
    "DS_JasperDbEnv" => 'production',
    "DS_JasperDisplaySections" => '1,2,3,4,5,6,7,8',
}

clear_workspace = false

1.upto(2) do |cnt|
  print "Adding chain ##{cnt}..."
  new_chain = TaskChain.create!(
    :schedule => schedule.to_hash,
    :name     => "Scheduled Task Chain #{cnt}",
    :user_id  => user,
    :last_run_at  => Time.now,
    :next_run_at  => Time.now,
    :workspace_id => workspace.id,
    :clear_workspace_before_run => clear_workspace,
  )

  new_task = ScheduledTask.create!(
    :kind => 'scan',
    :state => '',
    :position => 1,
    :last_run_at => Time.now,
    :last_run_status => 'success',
    :task_chain_id => new_chain.id,
    :config_hash => discover_config
  )

  new_task = ScheduledTask.create!(
    :kind => 'exploit',
    :state => '',
    :position => 2,
    :last_run_at => Time.now,
    :last_run_status => 'success',
    :task_chain_id => new_chain.id,
    :config_hash => exploit_config
  )

  new_task = ScheduledTask.create!(
    :kind => 'report',
    :state => '',
    :position => 3,
    :last_run_at => Time.now,
    :last_run_status => 'success',
    :task_chain_id => new_chain.id,
    :config_hash => report_config
  )
  puts "Done"
  clear_workspace = true
end
