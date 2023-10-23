module Metasploit::Pro::AddressUtils
  require 'ipaddr'

  # Takes an Array of IP Address strings and returns a string
  # accurately representing the ranges of ip addresses in the
  # Array.
  #
  # @param :ip_array [Array<String>] the array of IP Address Strings
  # @return [String] the string representing the ranges involved
  # @example
  #   Metasploit::Pro::AddressUtils.array_to_range_strings([[ "192.168.1.1", "192.168.1.3", "192.168.2.2", "192.168.1.2", "192.168.2.3", "192.168.2.4", "10.20.39.4"]]) => "10.20.39.4,192.168.1.1-192.168.1.3,192.168.2.2-192.168.2.4"
  def self.array_to_range_strings(ip_array=[])
    ip_addrs = ip_array.map{|ip| IPAddr.new(ip) }
    ip_ranges = ip_addrs.compact.sort.uniq.inject([]) do |ranges,ip_string|
      if ranges.empty? || ranges.last.last.succ != ip_string
        ranges << (ip_string..ip_string)
      else
        ranges[0..-2] << (ranges.last.first..ip_string)
      end
    end
    ip_range_strings = []
    ip_ranges.each do |range|
      first_ip = range.first
      last_ip  = range.last
      if first_ip == last_ip
        ip_range_strings << "#{first_ip}"
      else
        ip_range_strings << "#{first_ip}-#{last_ip}"
      end
    end
    ip_range_strings.join(" , ")
  end

  # Shortcut for expand_ip_ranges with options set applicable to CIDR ranges
  # @param [String] cidr_ip_range_str an IP address string that can contain a CIDR range
  # @return [String] with any CIDR ranges expanded
  def self.expand_cidr(cidr_ip_range_str, opts={})
    defaults = {
        :allow_wildcard => false,
        :allow_dash => false,
        :allow_tags => false
    }
    opts = defaults.merge(opts)
    expand_ip_ranges(cidr_ip_range_str, opts)
  end

  # Given a string of addresses and options to provide their context, expands all
  # ranges of addresses. Invalid entries based on passed options are dropped.
  # @param [String] ip_range_str an IP address string that can contain wildcard
  #   (1.1.1.*) ranges, dashed (1.1.1.1-1.1.1.2) ranges, tag references (#windows),
  #   or CIDR (1.2.2/24) ranges
  # @param [Hash] opts the options to expand the range with
  # @option opts [Boolean] :allow_cidr expands cidr ranges (1.1.1/24). Defaults to true.
  # @option opts [Boolean] :allow_wildcard expands wildcard ranges (1.1.1.*). Defaults to true.
  # @option opts [Boolean] :allow_dash expands dashed ranges (1.1.1.1-1.1.1.4). Defaults to true.
  # @option opts [Boolean] :allow_tags maps tag names to the IP addresses of matching hosts
  #   in the workspace. Defaults to true.
  # @option opts [Mdm::Workspace] :workspace. Required when :allow_tags is true.
  #   Defaults to the @workspace ivar.
  # @return [Array] with each allowed expanded range
  def self.expand_ip_ranges(ip_range_str, opts={})
    ip_range_str ||= ''
    ip_range_str = ip_range_str.to_s

    defaults = { :allow_cidr     => true,
                 :allow_wildcard => true,
                 :allow_dash     => true,
                 :allow_tags     => true }

    opts = defaults.merge(opts)

    # normalize spaced-dash (e.g. rewrite "1.1.1.1 - 1.1.1.3" to "1.1.1.1-1.1.1.3")
    ip_range_str.gsub!(/\s+-\s+/, '-')

    # normalize comma separation into space separation
    # space delimited is what we expect but using commas is
    # user expected behaviour so we should handle it gracefully
    ip_range_str.gsub!(/,/,' ')

    # If at least one type of relevant expansion is allowed,
    # expand the string:
    if (opts[:allow_cidr]     and ip_range_str.include?('/'))  or
       (opts[:allow_wildcard] and ip_range_str.include?('.*')) or
       (opts[:allow_dash]     and ip_range_str.include?('-'))  or
       (opts[:allow_tags]     and ip_range_str.include?('#'))
      # Handle each whitespaced element:
      elements = ip_range_str.strip.split(/\s+/).collect do |line|
        next unless range_valid_for_options?(line, opts)
        begin
          # Handle tags
          if line.start_with?('#')
            workspace = opts.fetch(:workspace, @workspace)
            workspace.hosts.tag_search(line.gsub(/^#/, '')).map(&:address)
          # Everything else
          else
            ips = []
            range_walker = Rex::Socket::RangeWalker.new(line)
            # Very limited validation:
            if range_walker.num_ips > 65536
              raise RuntimeError, "IP address range is too large (maximum is 65,536 hosts)"
            end
            range_walker.each { |ip| ips << ip }
            ips
          end
        rescue # ignore any bad parsing errors, just try to walk
          next
        end
      end
      elements.flatten.compact

    # If not, no need to parse, just return input
    else
      # Handle cases like having dashes in expand_cidr
      if range_valid_for_options?(ip_range_str, opts)
        ip_range_str.split(/\s+/)
      else
        []
      end
    end
  end

  # Validate if an option is set to false but the data
  # includes ranges that could be expanded with that option
  # @param range_str [String] of space/newline separated addresses
  # @param opts [Hash] options for the passed range
  # @return [Boolean] if the passed range is valid for the passed options
  def self.range_valid_for_options?(range_str, opts)
    dashed_bad   = !opts[:allow_dash] && range_str.include?('-')
    wildcard_bad = !opts[:allow_wildcard] && range_str.include?('*')
    tags_bad     = !opts[:allow_tags] && range_str.include?('#')
    cidr_bad     = !opts[:allow_cidr] && range_str.include?('/')
    if dashed_bad || wildcard_bad || tags_bad || cidr_bad
      false
    else
      true
    end
  end

  # returns local intranet/8 range, good for defaults
  def default_ip_range
    default_range = ""
    mine = Rex::Socket.source_address("50.50.50.50")
    if mine != "127.0.0.1"
      default_range = mine.sub(/\.\d+$/, ".1-254")
    end
    default_range
  end
end
