#!/usr/bin/env ruby
#
# $Id$

require 'fileutils'
root = File.expand_path(File.join(__FILE__, "..", "..", ".."))
tmp_dir = File.join(root, 'tmp', 'diagnostic_logs')

# Assume it's in the path
zip = "7za"
outfile = "diagnostics-" + Time.now.strftime("%Y%m%d%H%M") + ".zip"

logs = [
  File.join(root, "engine", "config", "logs", "framework.log"),
  File.join(root, "engine", "config", "logs", "db.log"),
  [File.join(root, "engine", "log", "production.log"), "engine-production.log"],
  [File.join(root, "engine", "log", "delayed_job.log"),"engine-delayed_job.log"],
  [File.join(root, "engine", "log", "audit.log"), "engine-audit.log"],
  File.join(root, "engine", "prosvc.log"),
  File.join(root, "engine", "prosvc_stderr.log"),
  File.join(root, "engine", "prosvc_stdout.log"),
  File.join(root, "engine", "license"),
  File.join(root, "engine", "version.yml"),
  File.join(root, "engine", "license.log"),
  File.join(root, "tasks"),
  File.join(root, "log", "install"),
  [File.join(root, "ui", "log", "production.log"), "ui-production.log"],
  File.join(root, "ui", "log", "thin.log"),
  File.join(root, "ui", "log", "delayed_job.log"),
  File.join(root, "ui", "log", "reports.log"),
  File.join(root, "ui", "log", "exports.log"),
  File.join(root, "ui", "log", "backups.log"),
  [File.join(root, "ui", "log", "audit.log"), "ui-audit.log"]
]

services = [
  ['metasploit-prosvc.service', 'prosvc_systemd.log'],
  ['metasploit-ui.service', 'thin_systemd.log'],
  ['metasploit-postgresql.service', 'postgresql_systemd.log'],
  ['metasploit-worker.service', 'delayed_job_systemd.log'],
  ['metasploit-update.service', 'update_systemd.log']
]


hide = " >/dev/null 2>&1"
if RUBY_PLATFORM =~ /mingw32/
  hide = "1>NUL 2>NUL"
elsif Process.euid != 0
  $stdout.puts("[-] This script needs root permissions.  Please run again as root")
  exit(1)
end

$stdout.puts %Q|

**************************************
*                                    *
*     Metasploit Diagnostic Logs     *
*                                    *
**************************************

[*] Make sure to shut down all Metasploit before running this script!!
[*] Creating archive of diagnostic logs...

|

# Copy the log files to a temp directory.  This needs to be done on
# Windows as 7zip can't access in-use files.
FileUtils.rm_r(tmp_dir) if File.exist?(tmp_dir)
FileUtils.mkdir_p(tmp_dir)
logs.each do |logfile, dst_name|
  next unless File.exist?(logfile)
  dst_name = File.basename(logfile) unless dst_name
  FileUtils.cp_r(logfile, File.join(tmp_dir, dst_name))
end
if File.exist?(File.expand_path(File.join(root, '..', '..', '.systemd_enabled')))
  services.each do |svc, dst_name|
    File.open(File.join(tmp_dir, dst_name), 'w') do |log|
      log.write `journalctl -u #{svc} -o short-iso`
    end
  end
end
system("#{zip} a #{outfile} #{tmp_dir} #{hide}")
FileUtils.rm_r(tmp_dir) if File.exist?(tmp_dir)

if (not File.exist? outfile)
  $stdout.puts "[-] Unable to create zip file.  Has the installation been corrupted?\n\n"
else
  $stdout.puts "[*] Created #{outfile} (#{File.size(outfile)} bytes)\n\n"
end

