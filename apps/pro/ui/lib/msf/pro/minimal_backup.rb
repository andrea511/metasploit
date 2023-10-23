require 'erb'
require 'fileutils'
require 'find'
require 'logger'
require 'json'
require 'time'
require 'yaml'
require 'zip'

# Filesystem size checks, not strictly necessary so we can skip if needed to
# rescue a borked install
require 'sys-filesystem' rescue nil

require 'msf/pro/locations'
require 'metasploit/pro/version'

module Msf
module Pro
###
#
# This class can create a simple backup _without_ the need for a functional
# rails install. See the Backup model for the full integration with rails-y
# bits.
#
###
class MinimalBackup
  # Convenience reference to get common application locations:
  include Msf::Pro::Locations
  def self.locations
    @_locations ||= Object.new.extend(Msf::Pro::Locations)
  end

  LOG_FILE = File.join(locations.pro_ui_log_directory, 'backups.log')
  FILE_EXTENSION = '.zip'.freeze

  attr_reader :date
  attr_reader :db_version
  attr_reader :description
  attr_reader :errors
  attr_reader :ms_revision
  attr_reader :ms_version
  attr_reader :name
  attr_reader :require_restart
  attr_reader :size
  attr_reader :status
  attr_reader :zip_file
  attr_reader :zip_size

  def self.generate(filename, description, overwrite: true, tee: nil, delay: false)
    archive = new(filename, overwrite: overwrite, tee: tee)

    archive.generate if archive.valid? && archive.create_empty_zip(description)
  rescue => e
    logger.error e
    false
  end

  def self.restore_alternate(filepath, overwrite: false, tee: nil, delay: false)
    archive = new(filepath, overwrite: overwrite, tee: tee)
    raise RuntimeError.new('Backup does not exist') unless archive.description
    raise RuntimeError.new('Backup is from a newer version of Metasploit') unless archive.compatible?

    archive.mark_restore_queued
    archive.restore_alternate

    archive
  end

  def self.delete(name)
    archive = new(name)
    File.delete(archive.zip_file) rescue Errno::ENOENT
  end

  def self.all
    ret = []
    Dir.glob(File.join(locations.pro_backups_directory, '*.zip')) do |file|
      ret << new(File.basename(file, '.zip'))
    end

    ret
  end

  def self.running?
    if defined? @@proc
      ret = Process.wait2 @@proc.pid, Process::WNOHANG
      if ret == nil
        output = @@proc.gets(nil)
        logger.info(output) if output
        true
      else
        @@retval = ret[1]
        false
      end
    else
      false
    end
  end

  def initialize(name, name_as_path: false, overwrite: false, tee: nil)
    self.class.initialize_settings!

    @errors = {}

    if name_as_path
      @name = File.basename(name, FILE_EXTENSION)
      @zip_file = File.expand_path(name)
    else
      @name = name
      @zip_file = File.expand_path(name + FILE_EXTENSION, @@backups_dir).freeze
      unless @zip_file.start_with?(@@backups_dir)
        @zip_file = ""
        @errors.merge!({name_error: "Cannot create or restore backup outside the backups directory from the web interface"})
      end
    end

    @overwrite = overwrite
    @tee = tee

    Zip::File.open(@zip_file) do |archive|
      manifest = JSON.parse(archive.comment)
      @description = manifest['description']
      @date = Time.parse(manifest['date'])
      @size = manifest['size'].to_i
      @zip_size = File.size(@zip_file)
      @status = manifest['status']
      @ms_version = manifest['ms_version']
      @ms_revision = manifest['ms_revision']
      @db_version = manifest['db_version']
      @require_restart = manifest['require_restart']
    end if File.exist?(@zip_file) && !File.directory?(@zip_file)
  end

  def valid?
    valid_name? && verify_available_generate_space?
  end

  def valid_name?
    backup_names = self.class.all.map(&:name)

    if !overwrite && backup_names.include?(name)
      errors.merge!({name_error: "Name is already being used."})
      false
    elsif name.empty?
      errors.merge!({name_error: "Name can't be blank."})
      false
    elsif name =~ /[\\\/]/
      errors.merge!({name_error: 'Name can\'t contain "\" or "/" .'})
      false
    else
      true
    end
  end

  def create_empty_zip(description)
    FileUtils.mkdir_p(self.class.locations.pro_backups_directory)

    return false unless verify_available_generate_space?

    @size = 0
    @description = description
    @date = Time.new.iso8601
    @ms_version = Metasploit::Pro::Version.version
    @ms_revision = Metasploit::Pro::Version.revision
    @db_version = current_db_version

    Zip::File.open(@zip_file, Zip::File::CREATE) do |archive|
      write_status(archive, '0/6: Queuing backup')
    end

    true
  end

  def compatible?
    @db_version <= current_db_version
  end

  def mark_restore_queued
    verify_available_restore_space

    Zip::File.open(@zip_file) do |archive|
      write_status(archive, '0/6: Queuing restore')
    end
  end

  def generate
    return false unless verify_available_generate_space?

    logger.info('Creating backup...')

    logger.info('Creating database backup...')
    generate_db_dump
    logger.info('Database backup created!')
    Zip::File.open(@zip_file, Zip::File::CREATE) do |archive|
      loc_count = 1
      @@locations.each do |fs_dir, zip_dir|
        write_status(archive, "#{loc_count}/6: Backing up #{fs_dir}")
        loc_count += 1

        logger.info("Copying #{fs_dir}...")
        Dir.glob(File.join(fs_dir, '*')) do |file|
          stored = File.join(zip_dir, File.basename(file))
          @size += File.size(file)
          archive.add(stored, file)
        end
      end

      logger.info('Writing manifest...')

      write_status(archive, '5/6: Backing up the database')

      while self.class.running?
        sleep 0.4 # Chosen by fair dice roll
      end
      @size += File.size(@@pg_dump_location)
      archive.add('postgres.bak', @@pg_dump_location)

      write_status(archive, 'Backup: Complete')
    end
    File.delete(@@pg_dump_location)
    @zip_size = File.size(@zip_file)

    logger.info('Backup generation complete!')
    logger.info('------------------------------')

    true
  end

  # XXX Never, ever run this in the context of a rails server
  def restore_alternate
    verify_available_restore_space
    create_alt_database if rails_env != 'production'
    Zip::File.open(@zip_file) do |archive|
      loc_count = 1
      @@locations.each do |fs_dir, zip_dir|
        write_status(archive, "#{loc_count}/6: Restoring #{fs_dir}")
        loc_count += 1

        logger.info("Extracting #{fs_dir}...")

        #Cleanup any previous temporary restore files
        extract_to = File.join(self.class.locations.pro_tmp_directory, zip_dir)
        FileUtils.remove_dir(extract_to, true)
        FileUtils.mkdir_p(extract_to)
        archive.glob(File.join(zip_dir, '*')) do |f|
          filepath = File.join(self.class.locations.pro_tmp_directory, f.name)
          FileUtils.mkdir_p(File.dirname(filepath))
          f.extract(filepath) { true } rescue Errno::EACCES
        end
        if rails_env == 'production'
          FileUtils.chown_R(File.stat(fs_dir).uid, nil, extract_to) rescue Errno::EPERM
        end
      end

      write_status(archive, '5/6: Restoring the database')
      logger.info('Extracting database backup...')

      dump = archive.find_entry('postgres.bak')
      dump.extract(@@pg_dump_location) { true }

      logger.info('Restoring database...')
      restore_alt_db_dump
      while self.class.running?
        # without the following line, the process hangs (?) leave the readlines here!
        @@proc.readlines
        sleep 0.4
      end
      # defensive code here for postgres failing during a restore
      unless @@retval.success?
        logger.info('Restoring database failed.')
      end

      write_status(archive, 'Restore: Complete', true)
    end

    File.delete(@@pg_dump_location)

    File.open(File.join(self.class.locations.pro_tmp_directory, 'swap_config'), 'w') { |f| f.write('1') }

    logger.info('Backup restore complete!')
    logger.info('------------------------------')
  end

  def ms_version_revision
    if @ms_revision
      "#{@ms_version}-#{@ms_revision}"
    else
      @ms_version
    end
  end

  def mark_restarted
    Zip::File.open(@zip_file) do |archive|
      write_status(archive, 'Restore: Complete', false)
    end
  end

  protected

  attr_accessor :overwrite
  attr_accessor :tee

  def self.logger
    unless defined? @@backup_logger
      File.exist?(LOG_FILE) || File.open(LOG_FILE, 'w') {|f| f.write('')}
      @@backup_logger = Logger.new(LOG_FILE)
      @@backup_logger.level = Logger::INFO
      @@backup_logger.formatter = proc do |severity, datetime, program_name, msg|
        if msg.respond_to? :backtrace
          "#{severity}: #{datetime}: #{msg}\nBacktrace:\n  #{msg.backtrace.join("\n  ")}"
        else
          "#{severity}: #{datetime}: #{msg}\n"
        end
      end
    end

    @@backup_logger
  end

  def logger
    self.class.logger
  end

  def write_status(archive, status, require_restart = false)
    @status = status
    @require_restart = require_restart
    archive.comment = {
      'description' => @description,
      'date' => @date,
      'size' => @size,
      'status' => @status,
      'ms_version' => @ms_version,
      'ms_revision' => @ms_revision,
      'db_version' => @db_version,
      'require_restart' => @require_restart
    }.to_json
    archive.commit

    if tee
      tee.puts status
    end
  end

  def generate_db_dump
    # TODO Error handling
    @@proc = IO.popen(postgres(:dump, ['-Fc', '-f', @@pg_dump_location, @@pg_db]))
  end

  def restore_alt_db_dump
    @@proc = IO.popen(postgres(:restore, ['-c', '-d', @@pg_alt_db, @@pg_dump_location]))
  end

  def available_space
    if defined? Sys
      logger.info('Verifying available space...')
      stat = Sys::Filesystem.stat(__dir__)
      stat.block_size * stat.blocks_available / 1000000.0
    else
      logger.info('Could not find filesystem gem, skiping available space check.')
      2 ** 32
    end
  end

  def verify_available_restore_space
    mb_estimate = @size / 1000000.0
    unless available_space > mb_estimate
      msg = "Not enough available disk space: #{mb_estimate.round(2)}MB needed for restore, #{available_space.round(2)}MB currently available."
      logger.fatal msg
      raise RuntimeError, msg
    end
  end

  def verify_available_generate_space?
    mb_estimate = 0
    @@locations.keys.each do |path|
      mb_estimate += directory_size(path) if File.exist? path
    end
    postgres_size = IO.popen(postgres(@@pg_db), "r+") do |io|
      q = "SELECT pg_size_pretty(pg_database_size('#{@@pg_db}'));"
      io.puts(q)
      logger.info(q)
      logger.info(io.gets.chomp) # pg_size_pretty
      logger.info(io.gets.chomp) # ---------------
      size = io.gets.chomp #           42 MB
      logger.info(size)
      size.strip.split.first.to_i
    end
    mb_estimate += 1.5 * postgres_size
    unless available_space > mb_estimate
      msg = "Not enough available disk space: #{mb_estimate.round(2)}MB needed for backup, #{available_space.round(2)}MB currently available."
      logger.fatal msg
      errors.merge!({size_error: msg})
      return false
    end
    true
  end

  def create_alt_database
    db_exists = false
    IO.popen(postgres([@@pg_db]), "r+") do |io|
      q = "SELECT 1 FROM pg_database WHERE datname='#{@@pg_alt_db}';"
      io.puts(q)
      logger.info(q)
      logger.info(io.gets.chomp)
      logger.info(io.gets.chomp)
      s = io.gets.chomp
      logger.info(s)
      db_exists = s.strip == "1"
    end

    unless db_exists
      IO.popen(postgres(@@pg_db), "r+") do |io|
        q = "CREATE DATABASE #{@@pg_alt_db};"
        io.puts(q)
        logger.info(q)
        logger.info(io.gets.chomp)
        q = "ALTER DATABASE #{@@pg_alt_db} owner to #{@@pg_user};"
        io.puts(q)
        logger.info(q)
        logger.info(io.gets.chomp)
      end
    end
  end

  def postgres(bin=nil, args)
    command_path = resolve_cmd(bin)

    if @@pg_pass
      # A normal password setup
      [{'PGPASSWORD' =>  @@pg_pass}, command_path, '-U', @@pg_user, "--port=#{@@pg_port}", *args, err: [:child, :out]]
    else
      # Uses domain socket authentication
      [command_path, '-U', @@pg_user, *args, err: [:child, :out]]
    end
  end

  def resolve_cmd(bin=nil)
    # Postgres bins on Windows have an extension, unlike Linux:
    postgres_bin_extension = (RUBY_PLATFORM =~ /^win|mingw/ ? '.exe' : nil)
    _command_path = if rails_env == 'production'
       if bin && !bin.empty? # Avoid `#present` since we aren't guaranteed rails
         File.join(self.class.locations.pro_install_directory, 'postgresql', 'bin', "pg_#{bin}#{postgres_bin_extension}")
       else
         File.join(self.class.locations.pro_install_directory, 'postgresql', 'bin', "psql#{postgres_bin_extension}")
       end
     else
       # If not in an installer environment, presume development/not Windows:
       bin.nil? ? `which psql`.chomp : `which pg_#{bin}`.chomp
     end
  end

  def self.initialize_settings!
    @@backups_dir  = locations.pro_backups_directory
    template = ERB.new(File.new("#{locations.pro_config_directory}/database.yml").read)
    db_settings = YAML.load template.result(binding)
    env_settings = db_settings[rails_env]

    @@pg_user = env_settings['username']
    @@pg_pass = env_settings['password']
    @@pg_port = env_settings['port']
    @@pg_db   = env_settings['database']
    @@pg_alt_db = @@pg_db + "_alt"
    @@locations = {
      locations.pro_loot_directory => 'loot',
      locations.pro_report_artifact_directory => 'report',
      locations.pro_ui_log_directory => 'ui_log',
      locations.pro_tasks_directory => 'task',
      locations.pro_rc_scripts_directory => 'rc_scripts'
    }
    @@pg_dump_location = File.join(locations.pro_tmp_directory, 'postgres.bak')
  end

  def directory_size(path)
    size = 0
    Find.find(path) do|f|
      size += File.size(f) if File.file?(f)
    end
    size/1000000.0
  end

  def current_db_version
    @current_db_version ||= IO.popen(postgres(@@pg_db), "r+") do |io|
      # Grab only version numbers that start with a year to avoid ancient-style
      # rails migration numbers
      q = "SELECT version FROM schema_migrations WHERE version LIKE '____%' ORDER BY version DESC LIMIT 1;"
      io.puts(q)
      logger.info(q)
      logger.info(io.gets.chomp) # version
      logger.info(io.gets.chomp) # -------
      v = io.gets.chomp #         20200501000000
      logger.info(v)
      v.strip.to_i
    end
  end

  # Oh the things we do to avoid needing a fully booted rails install
  def self.rails_env
    ENV['RAILS_ENV'] || 'development'
  end

  def rails_env
    self.class.rails_env
  end
end

end
end
