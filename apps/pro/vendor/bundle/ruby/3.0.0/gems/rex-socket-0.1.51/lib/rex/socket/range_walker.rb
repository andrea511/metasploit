# -*- coding: binary -*-
require 'rex/socket'

module Rex
module Socket

###
#
# This class provides an interface to enumerating an IP range
#
# This class uses start,stop pairs to represent ranges of addresses.  This
# is very efficient for large numbers of consecutive addresses, and not
# show-stoppingly inefficient when storing a bunch of non-consecutive
# addresses, which should be a somewhat unusual case.
#
# @example
#   r = RangeWalker.new("10.1,3.1-7.1-255")
#   r.include?("10.3.7.255") #=> true
#   r.length #=> 3570
#   r.each do |addr|
#     # do something with the address
#   end
###
class RangeWalker

  MATCH_IPV4_RANGE = /^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})-([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})$/
  private_constant :MATCH_IPV4_RANGE

  # The total number of IPs within the range
  #
  # @return [Fixnum]
  attr_reader :length

  # for backwards compatibility
  alias :num_ips :length

  # A list of the {Range ranges} held in this RangeWalker
  # @return [Array]
  attr_reader :ranges

  # Initializes a walker instance using the supplied range
  #
  # @param parseme [RangeWalker,String]
  def initialize(parseme)
    if parseme.is_a? RangeWalker
      @ranges = parseme.ranges.dup
    else
      @ranges = parse(parseme)
    end
    reset
  end

  #
  # Calls the instance method
  #
  # This is basically only useful for determining if a range can be parsed
  #
  # @return (see #parse)
  def self.parse(parseme)
    self.new.parse(parseme)
  end

  #
  # Turn a human-readable range string into ranges we can step through one address at a time.
  #
  # Allow the following formats:
  #   "a.b.c.d e.f.g.h"
  #   "a.b.c.d, e.f.g.h"
  # where each chunk is CIDR notation, (e.g. '10.1.1.0/24') or a range in nmap format (see {#expand_nmap})
  #
  # OR this format
  #   "a.b.c.d-e.f.g.h"
  # where a.b.c.d and e.f.g.h are single IPs and the second must be
  # bigger than the first.
  #
  # @param parseme [String]
  # @return [self]
  # @return [false] if +parseme+ cannot be parsed
  def parse(parseme)
    return nil unless parseme

    ranges = []
    parseme.split(', ').map{ |a| a.split(' ') }.flatten.each do |arg|
      # Remove trailing commas that may be unneeded, i.e. '1.1.1.1,'
      arg = arg.sub(/,+$/, '')

      # Handle IPv6 CIDR first
      if arg.include?(':') && arg.include?('/')
        next if (new_ranges = parse_ipv6_cidr(arg)).nil?

      # Handle plain IPv6 next (support ranges, but not CIDR)
      elsif arg.include?(':')
        next if (new_ranges = parse_ipv6(arg)).nil?

      # Handle IPv4 CIDR
      elsif arg.include?("/")
        next if (new_ranges = parse_ipv4_cidr(arg)).nil?

      # Handle hostnames
      elsif arg =~ /[^-0-9,.*]/
        next if (new_ranges = parse_hostname(arg)).nil?

      # Handle IPv4 ranges
      elsif arg =~ MATCH_IPV4_RANGE
        # Then it's in the format of 1.2.3.4-5.6.7.8
        next if (new_ranges = parse_ipv4_ranges(arg)).nil?

      else
        next if (new_ranges = expand_nmap(arg)).nil?
      end

      ranges += new_ranges
    end

    # Remove any duplicate ranges
    ranges = ranges.uniq

    return ranges
  end

  #
  # Resets the subnet walker back to its original state.
  #
  # @return [self]
  def reset
    return false if not valid?
    @curr_range_index = 0
    @curr_addr = @ranges.first.start
    @length = 0
    @ranges.each { |r| @length += r.length }

    self
  end

  # Returns the next host in the range.
  #
  # @return [Hash<Symbol, String>] The next host in the range
  def next_host
    return unless valid?

    if (@curr_addr > @ranges[@curr_range_index].stop)
      # Then we are at the end of this range. Grab the next one.

      # Bail if there are no more ranges
      return nil if (@ranges[@curr_range_index+1].nil?)

      @curr_range_index += 1

      @curr_addr = @ranges[@curr_range_index].start
    end

    range = @ranges[@curr_range_index]
    addr = Rex::Socket.addr_itoa(@curr_addr, range.ipv6?)

    if range.options[:scope_id]
      addr = addr + '%' + range.options[:scope_id]
    end

    hostname = range.is_a?(Host) ? range.hostname : nil

    @curr_addr += 1
    return { address: addr, hostname: hostname }
  end

  # Returns the next IP address.
  #
  # @return [String] The next address in the range
  def next_ip
    return nil if (host = next_host).nil?
    host[:address]
  end

  alias :next :next_ip

  # Whether this RangeWalker's ranges are valid
  def valid?
    (@ranges && !@ranges.empty?)
  end

  # Returns true if the argument is an ip address that falls within any of
  # the stored ranges.
  #
  # @return [true] if this RangeWalker contains +addr+
  # @return [false] if not
  def include?(addr)
    return false if not @ranges
    if (addr.is_a? String)
      addr = Rex::Socket.addr_atoi(addr)
    end
    @ranges.map { |r|
      if addr.between?(r.start, r.stop)
        return true
      end
    }
    return false
  end

  #
  # Returns true if this RangeWalker includes *all* of the addresses in the
  # given RangeWalker
  #
  # @param other [RangeWalker]
  def include_range?(other)
    return false if (!@ranges || @ranges.empty?)
    return false if !other.ranges || other.ranges.empty?

    # Check that all the ranges in +other+ fall within at least one of
    # our ranges.
    other.ranges.all? do |other_range|
      ranges.any? do |range|
        other_range.start.between?(range.start, range.stop) && other_range.stop.between?(range.start, range.stop)
      end
    end
  end

  #
  # Calls the given block with each address. This is basically a wrapper for
  # {#next_ip}
  #
  # @return [self]
  def each_ip(&block)
    while (ip = next_ip)
      block.call(ip)
    end
    reset

    self
  end

  alias each each_ip

  def each_host(&block)
    while (host_hash = next_host)
      block.call(host_hash)
    end
    reset

    self
  end

  #
  # Returns an Array with one element, a {Range} defined by the given CIDR
  # block.
  #
  # @see Rex::Socket.cidr_crack
  # @param arg [String] A CIDR range
  # @return [Range]
  # @return [false] if +arg+ is not valid CIDR notation
  def expand_cidr(arg)
    start,stop = Rex::Socket.cidr_crack(arg)
    if !start or !stop
      return
    end
    range = Range.new
    range.start = Rex::Socket.addr_atoi(start)
    range.stop = Rex::Socket.addr_atoi(stop)
    range.options = { :ipv6 => (arg.include?(":")) }

    return range
  end

  #
  # Expands an nmap-style host range x.x.x.x where x can be simply "*" which
  # means 0-255 or any combination and repitition of:
  #    i,n
  #    n-m
  #    i,n-m
  #    n-m,i
  # ensuring that n is never greater than m.
  #
  # non-unique elements will be removed
  #  e.g.:
  #    10.1.1.1-3,2-2,2 =>  ["10.1.1.1", "10.1.1.2", "10.1.1.3"]
  #    10.1.1.1-3,7 =>  ["10.1.1.1", "10.1.1.2", "10.1.1.3", "10.1.1.7"]
  #
  # Returns an array of Ranges
  #
  def expand_nmap(arg)
    # Can't really do anything with IPv6
    return if arg.include?(":")

    # nmap calls these errors, but it's hard to catch them with our
    # splitting below, so short-cut them here
    return if arg.include?(",-") or arg.include?("-,")

    bytes = []
    sections = arg.split('.')
    return unless sections.length == 4  # Too many or not enough dots

    sections.each { |section|
      if section.empty?
        # pretty sure this is an unintentional artifact of the C
        # functions that turn strings into ints, but it sort of makes
        # sense, so why not
        #   "10...1" => "10.0.0.1"
        section = "0"
      end

      if section == "*"
        # I think this ought to be 1-254, but this is how nmap does it.
        section = "0-255"
      elsif section.include?("*")
        return
      end

      # Break down the sections into ranges like so
      # "1-3,5-7" => ["1-3", "5-7"]
      ranges = section.split(',', -1)
      sets = []
      ranges.each { |r|
        bounds = []
        if r.include?('-')
          # Then it's an actual range, break it down into start,stop
          # pairs:
          #   "1-3" => [ 1, 3 ]
          # if the lower bound is empty, start at 0
          # if the upper bound is empty, stop at 255
          #
          bounds = r.split('-', -1)
          return if (bounds.length > 2)

          bounds[0] = 0   if bounds[0].nil? or bounds[0].empty?
          bounds[1] = 255 if bounds[1].nil? or bounds[1].empty?
          bounds.map!{|b| b.to_i}
          return if bounds[0] > bounds[1]
        else
          # Then it's a single value
          bounds[0] = r.to_i
        end
        return if bounds[0] > 255 or (bounds[1] and bounds[1] > 255)
        return if bounds[1] and bounds[0] > bounds[1]
        if bounds[1]
          bounds[0].upto(bounds[1]) do |i|
            sets.push(i)
          end
        elsif bounds[0]
          sets.push(bounds[0])
        end
      }
      bytes.push(sets.sort.uniq)
    }

    #
    # Combinitorically squish all of the quads together into a big list of
    # ip addresses, stored as ints
    #
    # e.g.:
    #  [[1],[1],[1,2],[1,2]]
    #  =>
    #  [atoi("1.1.1.1"),atoi("1.1.1.2"),atoi("1.1.2.1"),atoi("1.1.2.2")]
    addrs = []
    for a in bytes[0]
      for b in bytes[1]
        for c in bytes[2]
          for d in bytes[3]
            ip = (a << 24) + (b << 16) + (c << 8) + d
            addrs.push ip
          end
        end
      end
    end

    addrs.sort!
    addrs.uniq!

    rng = Range.new
    rng.options = { :ipv6 => false }
    rng.start = addrs[0]

    ranges = []
    1.upto(addrs.length - 1) do |idx|
      if addrs[idx - 1] + 1 == addrs[idx]
        # Then this address is contained in the current range
        next
      else
        # Then this address is the upper bound for the current range
        rng.stop = addrs[idx - 1]
        ranges.push(rng.dup)
        rng.start = addrs[idx]
      end
    end
    rng.stop = addrs[addrs.length - 1]
    ranges.push(rng.dup)
    return ranges
  end

  protected

  def parse_hostname(arg)
    begin
      ranges = Rex::Socket.getaddresses(arg).map { |addr| Host.new(addr, arg) }
    rescue Resolv::ResolvError, ::SocketError, Errno::ENOENT
      return
    end

    ranges
  end

  def parse_ipv4_cidr(arg)
    # Then it's CIDR notation and needs special case
    return if !valid_cidr_chars?(arg)

    ip_part, mask_part = arg.split("/")
    return unless (0..32).include? mask_part.to_i
    if ip_part =~ /^\d{1,3}(\.\d{1,3}){1,3}$/
      return unless Rex::Socket.is_ipv4?(ip_part)
    end

    begin
      hosts = Rex::Socket.getaddresses(ip_part).select { |addr| Rex::Socket.is_ipv4?(addr) } # drop non-IPv4 addresses
    rescue Resolv::ResolvError, ::SocketError, Errno::ENOENT
      return # Can't resolve the ip_part, so bail.
    end

    hosts.map { |addr| expand_cidr("#{addr}/#{mask_part}") }
  end

  def parse_ipv4_ranges(arg)
    # Note, this will /not/ deal with DNS names, or the fancy/obscure 10...1-10...2
    return unless arg =~ MATCH_IPV4_RANGE

    begin
      start, stop = Rex::Socket.addr_atoi($1), Rex::Socket.addr_atoi($2)
      return if start > stop # The end is greater than the beginning.
      range = Range.new(start, stop)
    rescue Resolv::ResolvError, ::SocketError, Errno::ENOENT
      return
    end

    [range]
  end

  def parse_ipv6(arg)
    opts = {}
    addrs = arg.split('-', 2)

    # Handle a single address
    if addrs.length == 1
      addr, scope_id = addrs[0].split('%')
      opts[:scope_id] = scope_id if scope_id
      opts[:ipv6] = true

      return unless Rex::Socket.is_ipv6?(addr)
      addr = Rex::Socket.addr_atoi(addr)
      range = Range.new(addr, addr, opts)
    else
      addr1, scope_id = addrs[0].split('%')
      opts[:scope_id] = scope_id if scope_id
      opts[:ipv6] = true

      addr2, scope_id = addrs[1].split('%')
      ( opts[:scope_id] ||= scope_id ) if scope_id

      # Both have to be IPv6 for this to work
      return unless (Rex::Socket.is_ipv6?(addr1) && Rex::Socket.is_ipv6?(addr2))

      # Handle IPv6 ranges in the form of 2001::1-2001::10
      addr1 = Rex::Socket.addr_atoi(addr1)
      addr2 = Rex::Socket.addr_atoi(addr2)

       range = Range.new(addr1, addr2, opts)
    end

    [range]
  end

  def parse_ipv6_cidr(arg)
    return if !valid_cidr_chars?(arg)

    ip_part, mask_part = arg.split("/")
    return unless (0..128).include? mask_part.to_i

    addr, scope_id = ip_part.split('%')
    return unless Rex::Socket.is_ipv6?(addr)

    range = expand_cidr(addr + '/' + mask_part)
    range.options[:scope_id] = scope_id if scope_id
    [range]
  end

  def valid_cidr_chars?(arg)
    return false if arg.include? ',-' # Improper CIDR notation (can't mix with 1,3 or 1-3 style IP ranges)
    return false if arg.scan("/").size > 1 # ..but there are too many slashes
    ip_part, mask_part = arg.split("/")
    return false if ip_part.nil? || ip_part.empty? || mask_part.nil? || mask_part.empty?
    return false if mask_part !~ /^[0-9]{1,3}$/ # Illegal mask -- numerals only
    true
  end

end

# A range of IP addresses
class Range

  #@!attribute start
  #   The first address in this range, as a number
  #   @return [Fixnum]
  attr_accessor :start
  #@!attribute stop
  #   The last address in this range, as a number
  #   @return [Fixnum]
  attr_accessor :stop
  #@!attribute options
  #   @return [Hash]
  attr_accessor :options

  # @param start [Fixnum]
  # @param stop  [Fixnum]
  # @param options [Hash] Recognized keys are:
  #   * +:ipv6+
  #   * +:scope_id+
  def initialize(start=nil, stop=nil, options=nil)
    @start = start
    @stop = stop
    @options = options || {}
  end

  # Compare attributes with +other+
  # @param other [Range]
  # @return [Boolean]
  def ==(other)
    (other.start == start && other.stop == stop && other.ipv6? == ipv6? && other.options == options)
  end

  # The number of addresses in this Range
  # @return [Fixnum]
  def length
    stop - start + 1
  end
  alias :count :length

  # Whether this Range contains IPv6 or IPv4 addresses
  # @return [Boolean]
  def ipv6?
    options[:ipv6]
  end
end

# A single host
class Host < Range
  attr_accessor :hostname

  def initialize(address, hostname=nil, options={})
    if address.is_a? String
      options.merge!({ ipv6: Rex::Socket.is_ipv6?(address) }) if options[:ipv6].nil?
      address = Rex::Socket.addr_atoi(address)
    end

    super(address, address, options)
    @hostname = hostname
  end

  def address
    Rex::Socket.addr_itoa(@start)
  end

end
end
end
