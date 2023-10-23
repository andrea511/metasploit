require 'open3'

class Apps::FirewallEgress::Scan

  # Raised in situations where scans wouldn't work
  class ScanLogicError < Exception; end

  if Rails.env == "production"
    EGADZ_TARGET = "egadz.metasploit.com"
  else
    EGADZ_TARGET = "egadz-dev.metasploit.com"
  end

  # The Nmap states that Egadz looks at
  EGADZ_TRACKED_PORT_STATES = [:open, :closed, :filtered]

  # The EGADZ target
  attr_reader :dst_host
  # Holds state - used to communicate stop conditions between scan/capture threads
  attr_reader :scan_complete
  # Holds state - used to hold the return code of the nmap scan process
  attr_reader :scan_proc_status
  # File where nmap results will be
  attr_reader :output_file_path
  # The module task that is running this
  attr_reader :task_id
  # The port the scan starts on
  attr_accessor :nmap_start_port
  # The port the scan stops on
  attr_accessor :nmap_stop_port
  # The array of ResultRange objects that is built up by the scanner
  attr_accessor :result_ranges
  # The state in the <extraports> tag if there is one
  attr_accessor :extra_ports_state

  # Create attr_accessors and default getters for RunStat objects
  # ex: open_port_count
  EGADZ_TRACKED_PORT_STATES.each do |state|
    attr_name = "#{state}_port_count".to_sym
    attr_accessor attr_name

    define_method(attr_name) do
      ivar_name = "@#{attr_name}"
      unless instance_variable_defined? ivar_name
        run_stat = ::RunStat.new(:name => attr_name, :task_id => task_id, :data => 0)
        run_stat.save
        instance_variable_set(ivar_name, run_stat)
      end
      instance_variable_get ivar_name
    end
  end

  # Determine whether the given egress scan target hostname can be resolved.
  #
  # @return [Boolean] true if hostname is valid
  def valid_dst_host?
    begin
      Rex::Socket.addr_atoi(@dst_host)
    rescue Resolv::ResolvError, ::SocketError, Errno::ENOENT
      return false
    end

    return true
  end

  # TODO: move this into a common validator in MDM
  def self.valid_port_range?(start, stop)
    return false unless start.is_a?(Integer) && stop.is_a?(Integer)
    return false unless start <= stop
    return false unless 0 <= start && start <= Apps::FirewallEgress::TaskConfig::MAX_PORT
    return false unless 0 <= stop  && stop  <= Apps::FirewallEgress::TaskConfig::MAX_PORT
    return true
  end

  # @param[Hash] args the options for the scan
  # @option args [String] :dst_host the EGADZ target to be scanned
  # @option args [Integer] :task_id the ID of the Mdm::Task that is running this scan, if any
  def initialize(args={})
    @dst_host         = args.fetch(:dst_host)
    @task_id          = args[:task_id]
    @nmap_start_port  = args[:nmap_start_port]
    @nmap_stop_port   = args[:nmap_stop_port]
    @scan_complete    = false
    @result_ranges    = []
    @extra_ports_state = ""
  end

  # @return[Array] the nmap command (and options) that will perform the scan
  def nmap_command
    ['nmap',
     '-sS',
     '-Pn',
     # This is needed for XML output to enumerate all port results,
     # versus showing a count per state:
     '-dd',
     '-n',
     '--max-retries=5',
     "#{nmap_port_arg}",
     '-oX',
     "#{output_file_path}",
     "#{dst_host}"
    ].reject(&:empty?)
  end

  # @return[String] the port range nmap argument,
  def nmap_port_arg
    if nmap_start_port.present? && nmap_stop_port.present?
      "-p#{nmap_start_port}-#{nmap_stop_port}"
    else
      ""
    end
  end

  # Kick off the nmap scan
  # @return[void]
  def start!
    nmap_proc           = Open3.capture3 *nmap_command
    @scan_proc_status   = nmap_proc
    @scan_complete      = true
  end

  # @return[Nokogiri::XML::Document] the parsed XML output from nmap
  def nokogiri_doc
    @nokogiri_doc ||= File.open(output_file_path) do |file|
      ::Nokogiri::XML(file)
    end
  end

  # @return[Array] an array of Nokogiri::XML::Element objects representing the ports data obtained by nmap
  def ports
    @ports ||= nokogiri_doc.xpath('//port')
    x = nokogiri_doc.xpath('//extraports')
    if x.length > 0 && x[0].get_attribute("count").to_i > 0
      @extra_ports_state = x[0].get_attribute("state")
    end
    @ports
  end

  # @return[Array] an array of pairs like "[1234, 'open']" -- each describes a
  # port
  def parsed_ports
    unless instance_variable_defined? :@parsed_ports
      active_ports = Array.new(65536, false)

      @parsed_ports = ports.inject([]) do |array, port_element|
        array << [port_number(port_element), port_state(port_element)]
        active_ports[port_number(port_element)] = true
        array
      end

      if @extra_ports_state.length > 0
        active_ports.each_with_index do |active, port|
          if port == 0
            next
          end
          if !active
            @parsed_ports << [port, @extra_ports_state]
          end
        end
      end
    end
    @parsed_ports
  end

  # @return[Array] the parsed ports that are in the provided state
  def parsed_ports_by_state(state_filter)
    parsed_ports.select{|port_pair| port_pair[1] == state_filter.to_s}
  end

  # @param[Nokogiri::XML::Element] A "port" element from nmap output XML
  # @return[String] the port state
  def port_state(port_element)
    port_element.xpath('state').first.attributes['state'].value
  end

  # @param[Nokogiri::XML::Element] A "port" element from nmap output XML
  # @return[Integer] the port number
  def port_number(port_element)
    port_element.attributes['portid'].value.to_i
  end

  # Iterate over the ports, identifying runs of same state and collecting them into ResultRange objects
  # Populate the scan's result_range array
  # @return[void]
  def build_all_result_ranges
    # The current ports we are tracking (a consecutive group in the same state)
    #puts "num of ports #{parsed_ports.length}"
    current_ports = [parsed_ports.first[0]]
    # The state of the current run we are tracking
    current_state = parsed_ports.first[1]

    parsed_ports.each_with_index do |port_pair, index|
      next if index == 0 # We've already initialized with the first item

      # Last port special cases:
      # It is either a range of length one or part of the running range (current_ports)
      if index == parsed_ports.size - 1

        # Range of 1 if it's not in current_state or IS in current_state but not contiguous with running range
        if port_pair[1] != current_state || port_pair[0] != current_ports.last + 1
          result_ranges << build_result_range(:start_port => port_pair[0], :end_port => port_pair[0], :state => port_pair[1])

          # It's part of existing running range
        else
          result_ranges << build_result_range(:start_port => current_ports.first, :end_port => port_pair[0], :state => port_pair[1])
        end
      end

      # The port either continues the range or saves the current and starts a new one
      # NOTE: the nature of creating ranges means that you'll see the last port pair created before
      # the penultimate port pair in the result_ranges array.
      # This is because the penultimate must be stored in current_state, current_port in order for the last
      # port_pair to be checked against it. This means that the last port_pair can get stored in current_ports,
      # but this doesn't matter -- since it's the last one, no new ResultRange will be created.
      if port_pair[1] == current_state && port_pair[0] == current_ports.last + 1
        current_ports << port_pair[0]
      else
        result_ranges << build_result_range(:start_port => current_ports.first,
                                            :end_port   => current_ports.last,
                                            :state      => current_state)

        # Reset the range and state to start w/ the new port
        current_state = port_pair[1]
        current_ports = [port_pair[0]]
      end
    end
  end

  # Saves all objects in the result_ranges array to the DB
  # @return[void]
  def save_result_ranges
    Apps::FirewallEgress::ResultRange.transaction do
      result_ranges.map(&:save)
    end
  end

  # Delete the nmap output XML file
  # @return[void]
  def delete_nmap_result
    File.unlink output_file_path
  end

  # @return[String] the absolute path to the directory where the Nmap output file will be saved
  def output_file_directory_path
    Dir.tmpdir
  end

  # @return[String] the complete path on the filesystem to the Nmap results XML file created by the scan
  def output_file_path
    @output_file_path ||= "#{output_file_directory_path}/#{Time.now.to_i}-egadz-results.xml"
  end

  # @return[Egadz::ResultRange] a ResultRange object that can be saved to the DB
  def build_result_range(args={})
    start_port = args.fetch(:start_port)
    end_port   = args.fetch(:end_port)
    Apps::FirewallEgress::ResultRange.new(
      start_port: start_port,
      end_port: end_port,
      state: args.fetch(:state),
      task_id: task_id,
      target_host: dst_host
    )
  end

end
