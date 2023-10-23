require 'erb'
require 'yaml'
require 'fileutils'
require 'timeout'

def properties
  p = {}
  File.open(File.join(@root, "properties.ini")) do |io|
    io.each do |line|
      if line[0] != '[' && line[-1] != ']' && !line.strip.empty?
        p[line.split('=', 2).first.strip] = line.split('=', 2).last.strip
      end
    end
  end if File.exist?(File.join(@root, "properties.ini"))
  p
end

def postgres
  # Postgres bins on Windows have an extension, unlike Linux:
  command_path = if @rails_env == 'production'
    File.join(@postgres_bin, "psql#{@postgres_bin_extension}")
  else
    # If not in an installer environment, presume development/not Windows:
    `which psql`.chomp
  end

  [{'PGPASSWORD' => @postgres_password}, command_path, '-U', @postgres_user, "--port=#{@postgres_port}", @postgres_db_alt, err: [:child, :out]]
end

def swap_files!
  root_dir = File.expand_path(File.join(File.dirname(__FILE__)))
  tmp_dir = File.expand_path(File.join(root_dir, '..','..','engine','tmp'))
  pro_dir = File.expand_path(File.join(root_dir, '..','..'))

  tmp_to_pro = {
      "loot" => "loot",
      "rc_scripts" => "rc_scripts",
      "report" => "reports/artifacts",
      "task" => "tasks",
      "ui_log" => "ui/log"
  }

  tmp_to_pro.each do |tmp, pro|
    tmp_files = File.join(tmp_dir, tmp, '*')
    pro_save_dir = File.join(pro_dir, pro)
    puts "Copy #{tmp_files} to #{pro_save_dir}"
    FileUtils.mkdir_p(File.join(tmp_dir, tmp))
    FileUtils.mkdir_p(File.join(tmp_dir, "#{tmp}_alt"))
    FileUtils.mv(Dir.glob(File.join(pro_save_dir, '*')).reject{|f|f.include?('backups.log') }, File.join(tmp_dir, "#{tmp}_alt"), :force => true)
    FileUtils.mv(Dir.glob(tmp_files).reject{|f|f.include?('backups.log') }, pro_save_dir, :force => true)
    FileUtils.rm_rf(File.join(tmp_dir, tmp))
    FileUtils.mv(File.join(tmp_dir, "#{tmp}_alt"), File.join(tmp_dir, tmp), :force => true)
  end
end

@root = File.expand_path(File.join(__FILE__, "..", "..", "..", "..", ".."))
@rails_env = ENV['RAILS_ENV'] || 'development'

swap_config = File.join(File.expand_path(File.join(__FILE__, '..','..', '..', 'engine', 'tmp')), 'swap_config')

# Bail early unless we are supposed to swap or we are being forced
unless (File.exist?(swap_config) && File.read(swap_config).strip == '1') || ARGV[0] == '-f'
  puts "Restored Pro data does not need to be swapped in"
  exit 0
end

template = ERB.new(File.new(File.join(File.expand_path(File.join(__FILE__, "..", "..")), "config", "database.yml")).read)
db_settings = YAML.load template.result(binding)
db_config_settings = db_settings[@rails_env]

@postgres_bin = properties['postgres_binary_directory']
@postgres_bin_extension = (RUBY_PLATFORM =~ /^win|mingw/ ? '.exe' : nil)
@postgres_password = properties['postgres_root_password'] || db_config_settings['password']
@postgres_user = if @rails_env == 'production'
                   'postgres'
                 else
                   db_config_settings['username']
                 end
@postgres_port = properties['postgres_port'] || db_config_settings['port']
@postgres_db = db_config_settings['database']
@postgres_db_alt = @postgres_db + "_alt"
@postgres_db_tmp = @postgres_db + "_tmp"

unless @rails_env == 'development'
  pg_status = nil
  begin
    Timeout::timeout(30) do
      while (pg_status =~ /accepting/i).nil?
        pg_status = `#{File.join(@postgres_bin, 'pg_isready')}#{@postgres_bin_extension} --port=#{@postgres_port}`
        sleep 1
      end
    end
  rescue Timeout::Error
    return 'Unable to start postgres'
  end
end

IO.popen(postgres, "r+") do |io|
  io.puts("ALTER DATABASE #{@postgres_db} rename to #{@postgres_db_tmp};")
  sleep 1
  io.gets
  io.puts("\\c #{@postgres_db_tmp};")
  sleep 1
  io.gets
  io.puts("ALTER DATABASE #{@postgres_db_alt} rename to #{@postgres_db};")
  sleep 1
  io.gets
  io.puts("\\c #{@postgres_db};")
  sleep 1
  io.gets
  io.puts("ALTER DATABASE #{@postgres_db_tmp} rename to #{@postgres_db_alt};")
  sleep 1
  io.gets
end

swap_files!

File.open(swap_config, 'w') { |f| f.write('0') }
