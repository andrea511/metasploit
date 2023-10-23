module Metasploit
  module Pro
    module HostSelection

      # Takes host selection form data and returns an array of
      # actual Host objects that match the criteria.
      #
      # @param :blacklist_str [String] any hosts to be excluded
      # @param :whitelist_str [String] hosts to be included
      # @param :workspace [Mdm::Workspace] the workspace to look for hosts in
      # @return [Array<Mdm::Host>] the Hosts that matched the selection criteria
      def self.hosts_from_form(blacklist_str, whitelist_str, workspace)
        whitelist_ips = Metasploit::Pro::AddressUtils.expand_ip_ranges(whitelist_str)
        blacklist_ips = Metasploit::Pro::AddressUtils.expand_ip_ranges(blacklist_str)

        # Remove any blacklisted IPs from the whitelist
        whitelist_ips = whitelist_ips - blacklist_ips
        whitelist_ips.reject! { |ip| ip == '127.0.0.1' }

        if whitelist_ips.empty?
          if blacklist_ips.empty?
            workspace.hosts.where(state: 'alive')
          else
            workspace.hosts.where("address not in (?)", blacklist_ips)
          end
        else
          workspace.hosts.where(state: 'alive', address: whitelist_ips)
        end
      end

    end
  end
end