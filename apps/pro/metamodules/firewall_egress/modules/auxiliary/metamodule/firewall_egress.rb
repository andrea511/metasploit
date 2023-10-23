#
# $Id$
##

##
# This file is part of the Metasploit Framework and may be subject to
# redistribution and commercial restrictions. Please see the Metasploit
# Framework web site for more information on licensing and terms of use.
# http://metasploit.com/framework/
##

require 'msf/core'
require 'msf/pro/apps/helpers'
require 'msf/pro/task'
require 'apps/firewall_egress/scan'

class MetasploitModule < Msf::Auxiliary
  include Msf::Pro::Task
  include Msf::Auxiliary::Report
  include Msf::Pro::Apps::Helpers

  attr_reader :scan, :scan_config

  def initialize
    super(
      'Name'        => 'Segmentation and Firewall Testing',
      'Description' => 'Command and control for testing which ports are open in an environment',
      'Author'      => 'Trevor Rosen',
      'License'     => 'Rapid7 Proprietary'
    )

    @command_mode = :single_threaded

    register_options([
      OptInt.new('APP_RUN_ID', [true, 'ID of the AppRun saved in the database.']),
    ])
  end

  def run
    @scan_config = app_run.config['scan_task']
    @scan = Apps::FirewallEgress::Scan.new(dst_host: scan_config['dst_host'], task_id: mdm_task.nil? ? nil : mdm_task.id)

    app_run.run!

    self.step_count = app_run_contains_report? ? 4 : 3

    if @scan_config['use_nmap_default_port_set']
      next_step "Starting scan of '#{scan.dst_host}' on nmap's default port range"
    else
      @scan.nmap_start_port = @scan_config['nmap_start_port']
      @scan.nmap_stop_port  = @scan_config['nmap_stop_port']
      next_step "Starting scan of '#{scan.dst_host}' on ports #{@scan.nmap_start_port} - #{@scan.nmap_stop_port}"
    end

    # initialize run stats to 0
    Apps::FirewallEgress::Scan::EGADZ_TRACKED_PORT_STATES.each do |state|
      scan.send("#{state}_port_count")
    end

    scan.start!

    if !@scan.valid_dst_host?
      print_error "Error running scan: Cannot resolve scan egress target hostname #{@scan.dst_host}"
      app_run.fail!
    elsif scan.scan_proc_status[2].exitstatus != 0
      errs = scan.scan_proc_status[1].encode('UTF-8', :invalid => :replace, :undef => :replace)
      print_error "Error running scan: #{errs}"
      app_run.fail!
    else
      begin
        next_step "Parsing nmap output"
        mdm_task.update(:progress => 85)

        # Update all RunStat objects
        Apps::FirewallEgress::Scan::EGADZ_TRACKED_PORT_STATES.each do |state|
          run_stat = scan.send("#{state}_port_count")
          run_stat.update(:data => scan.parsed_ports_by_state(state).size)
        end

        next_step "Creating result ranges in DB"
        scan.build_all_result_ranges
        scan.save_result_ranges
        if app_run_contains_report?
          next_step "Reporting"
          run_report
        end

        task_summary "Segmentation and Firewall Testing Finished."
      ensure
        scan.delete_nmap_result
      end
    end
  end

  # Called by ProTask object that runs the show
  # @return[Notifications::Message]
  def completed_notification
    content = "Discovered #{scan.result_ranges.size} port ranges"
    Notifications::Message.create(default_notification_options.merge(content: content))
  end
end
