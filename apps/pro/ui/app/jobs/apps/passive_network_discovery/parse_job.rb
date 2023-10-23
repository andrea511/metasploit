class Apps::PassiveNetworkDiscovery::ParseJob < Struct.new(:pnd_pcap_file_id)
  attr_reader :framework
  
  def perform
    pnd_pcap_file = Apps::PassiveNetworkDiscovery::PcapFile.find pnd_pcap_file_id
    pnd_pcap_file.update_attribute(:status, "processing")

    task = pnd_pcap_file.task
    filename = pnd_pcap_file.loot.path
    
    require_dependencies
    initalize_framework
    connect_framework_db
    kill_extra_threads
    
    framework.db.import_file(:filename => filename, :workspace => task.workspace, :task => task) do |type,data|
    	case type
  	  when :address
				puts "Importing host #{data}"
			when :service
				puts "Importing service #{data}"
    	when :pcap_count
        puts "Import: #{data} packets processed"
    	end
    end
    pnd_pcap_file.update_attribute(:status, "finished")
    
    kill_extra_threads_and_manager
  end
  
  def error(job, exception)
    pnd_pcap_file = Apps::PassiveNetworkDiscovery::PcapFile.find pnd_pcap_file_id
    pnd_pcap_file.update_attribute(:status, "error")    
  end

  def failure
    pnd_pcap_file = Apps::PassiveNetworkDiscovery::PcapFile.find pnd_pcap_file_id
    pnd_pcap_file.update_attribute(:status, "failure")    
  end
  
  private
  
  def require_dependencies
    require 'msf/core'
    require_dependency('msf/base')
  end
  
  def initalize_framework
    config_pathname  = Rails.root.join("../engine/job_config")
    config_path = config_pathname.to_s

    @framework = Msf::Simple::Framework.create(
      'ConfigDirectory' => config_path,
      'DeferModuleLoads' => true
    )
  end

  def connect_framework_db
    yaml_pathname = Rails.root.join.join('config', 'database.yml')
    dbinfo = YAML.load(yaml_pathname.read)
    db = dbinfo[Rails.env]

    framework.db.connect(db)
  end
  
  def kill_extra_threads
    thread_manager = framework.threads

    thread_manager.each do |thread|
      thread.kill
    end
  end
  
  def kill_extra_threads_and_manager
    thread_manager = framework.threads

    thread_manager.each do |thread|
      thread.kill
    end

    thread_manager.monitor.kill
  end
  
end
