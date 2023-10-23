module Metasploit::Pro::IpRangeValidation
  extend ActiveSupport::Concern

  #
  # Instance Methods
  #

  # Validates IP addresses or ranges. Used by anything
  # that takes an IP address.
  def valid_ip_or_range?(string)
    begin
      ip_range = Rex::Socket::RangeWalker.new(string)
    rescue
      false
    else
      ip_range.valid?
    end
  end

  # Validates IP address matches host in workspace
  def whitelist_matches_host_in_workspace
    if (whitelist_hosts & @workspace.hosts.pluck(:address).collect(&:to_s)).empty?
      errors.add :whitelist_string, "must match a host in the project"
    end
  end

  # Validates IP whitelist is valid
  def whitelist_valid
    expand_opts = {:workspace => @workspace}
    expanded_whitelist_hosts = expand_ip_ranges(whitelist_hosts,expand_opts)

    if expanded_whitelist_hosts.nil? or expanded_whitelist_hosts.empty?
      errors.add :whitelist_string, "At least one IP address is required"
    end

    expanded_whitelist_hosts.each do |ip|
      next if valid_ip_or_range?(ip)
      errors.add :whitelist_string,  "Invalid target IP address: #{ip}"
    end

    unless @workspace.allow_actions_on?(expanded_whitelist_hosts.join(" "))
      errors.add :whitelist_string, "Target Addresses must be inside workspace boundaries"
    end
  end


  # Validates IP address range for blacklist hosts
  def blacklist_valid
    expand_opts = {:workspace => @workspace}
    expanded_blacklist_hosts = expand_ip_ranges(blacklist_hosts,expand_opts)

    unless expanded_blacklist_hosts.nil?
      expanded_blacklist_hosts.each do |ip|
        next if valid_ip_or_range?(ip)
        errors.add :blacklist_string, "Invalid target IP address: #{ip}"
      end
    end
  end

  # Expand IP Address if has not yet been expanded
  def expand_ip_ranges(addrs, opts)
    if addrs.kind_of?(String)
      addrs = Metasploit::Pro::AddressUtils.expand_ip_ranges(
                         addrs || '', opts
                       )
    end
    addrs
  end

  #
  # Given session array of local_ids, returns the associated uniq addresses
  # @return [Array<String>] array of IP addresses for each session
  #
  def addresses_for_session_local_ids(local_ids)
    addresses = Mdm::Session.alive.
        joins(host: :workspace).
        where(Mdm::Workspace[:id].eq(@workspace.id)).
        where(local_id: local_ids).
        pluck(:address)

    addresses.compact.uniq.map(&:to_s)
  end

  #
  # Validates session IPs are within workspace boundaries
  # @return [Boolean]
  #
  def sessions_valid?
    addresses = addresses_for_session_local_ids(@sessions)
    addresses_string = addresses.join(" ")

    @workspace.allow_actions_on?(addresses_string)
  end

end