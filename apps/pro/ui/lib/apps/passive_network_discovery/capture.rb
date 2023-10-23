class Apps::PassiveNetworkDiscovery::Capture
  
  PACKETS_TO_NOTICE = 1_000
  
  def initialize(args = {})
    raise ArgumentError.new("ArgumentError: You must specify a task") unless args.has_key? :task
    @task = args[:task]
    
    @file_path      = args[:path]       || "."
    @file_prefix    = args[:prefix]     || "pcap-"
    @file_index     = args[:index]      || 0
    @timeout        = args[:timeout]    || 600
    @device         = args[:device]     || PCAPRUB::Pcap.lookupdev
    @snaplength     = args[:snaplength] || 65535
    @max_file_size  = args[:file_size]  || 64 * 1024 * 1024
    @max_total_size = args[:max_size]   || @max_file_size * 4
    @bpf            = args[:bpf]        || ""

    @file_size = 0
    @total_size = 0
    @capture_packets = 0    
    @promiscous_mode = true
    @filename = ''
  end
  
  def capture(&block)
    begin
      Timeout::timeout(@timeout) do
        @capture = Pcap.open_live(@device, @snaplength, @promiscous_mode, 0)
        @capture.setfilter(@bpf) if !@bpf.blank?
        while @total_size <= @max_total_size  do
          @file_index += 1
          @file_number = @file_index.to_s
          @filename = "#{@file_path}/#{@file_prefix}#{@file_number.rjust(3,"0")}.pcap"
          
          @loot = Mdm::Loot.create(:workspace => @task.workspace, :path => @filename)
          @pcap = Apps::PassiveNetworkDiscovery::PcapFile.create(
            :status => "unprocessed", 
            :loot => @loot,
            :task => @task
          )
          
          @file_size = 0
          dumper = @capture.dump_open(@filename)
          yield(:pcap_new_file, {:filename => @filename})
          @capture.each do |packet|
            @capture.dump(packet.length, packet.length, packet)
            @capture_packets += 1
            @file_size += packet.length
            @total_size += packet.length
            if @total_size >= @max_total_size || @file_size >= @max_file_size
              break
            elsif @capture_packets % PACKETS_TO_NOTICE == 0
              yield(:pcap_info, {:packets => @capture_packets, :current => @file_size, :total => @total_size})
            end
          end
          yield(:pcap_close_file, {:filename => @filename})
          yield(:pcap_info, {:packets => @capture_packets, :current => @file_size, :total => @total_size})
          @capture.dump_close
          Delayed::Job.enqueue Apps::PassiveNetworkDiscovery::ParseJob.new(@pcap.id)
        end
      end
    rescue Timeout::Error => e
      @capture.dump_close
    ensure
      yield(:pcap_close_file, {:filename => @filename})
      yield(:pcap_info, {:packets => @capture_packets, :current => @file_size, :total => @total_size})
      Delayed::Job.enqueue Apps::PassiveNetworkDiscovery::ParseJob.new(@pcap.id) if @pcap
    end
  end
end
