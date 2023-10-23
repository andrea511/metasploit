require 'msf/pro/apps/helpers'
require 'msf/pro/task'
require 'msf_module_commander'

module Msf
###
#
# This module provides shared methods for top-level Pro modules
#
###
module Pro
module Apps
module AuthChecks
  include Msf::Auxiliary::Report
  include Msf::Pro::Apps::Helpers
  include Msf::Pro::Task
  include MsfModuleCommander

  def initialize(info)
    super(info)

    @hosts_selected_count     = 0
    @services_selected_count  = 0
    @service_map              = {}
    @host_map                 = {}
    @command_mode             = :single_threaded

    register_options([
      OptInt.new('APP_RUN_ID',  [true,  'ID of the AppRun'])
    ])
  end

  def start_stats
    @selected_hosts = RunStat.new(
        :name => "Hosts Selected",
        :data => @hosts_selected_count,
        :task => mdm_task
    )
    @selected_hosts.save
    @selected_services = RunStat.new(
        :name => "Services Selected",
        :data => @services_selected_count,
        :task => mdm_task
    )
    @selected_services.save
    @hosts_tried_count  = RunStat.new(
        :name => "Hosts Tried",
        :data => 0,
        :task => mdm_task
    )
    @hosts_tried_count.save
    @services_tried_count = RunStat.new(
        :name => "Services Tried",
        :data => 0,
        :task => mdm_task
    )
    @services_tried_count.save
    @services_succeeded_count = RunStat.new(
        :name => "Successful Auths",
        :data => 0,
        :task => mdm_task
    )
    @services_succeeded_count.save
  end

  def update_found_creds
    app_run.reload
    @services_succeeded_count.data = app_run.tasks.first.credential_logins.count
    @services_succeeded_count.save
  end

  def update_hosts(addresses)
    addresses.each do |addr|
      @host_map[addr] -= 1
      if @host_map[addr] == 0
        @hosts_tried_count.data += 1
      end
      @services_tried_count.data +=1
    end
    @hosts_tried_count.save
    @services_tried_count.save
  end

  def add_to_service_map(port,address)
    if @service_map.has_key?(port)
      @service_map[port] << address
    else
      @service_map[port] = [address]
    end
    @services_selected_count += 1
  end

  def increment_host_map(address)
    if @host_map.has_key?(address)
      @host_map[address] += 1
    else
      @host_map[address] = 1
    end
  end

  def initiate_sweep(mod_name,opts,svc, addresses =nil)
    next_step "Trying #{svc} services on port #{opts['RPORT']} (via #{mod_name})"
    run_module(mod_name, opts)
    update_found_creds
    if addresses
      update_hosts(addresses)
    end
  end


end
end
end
end
