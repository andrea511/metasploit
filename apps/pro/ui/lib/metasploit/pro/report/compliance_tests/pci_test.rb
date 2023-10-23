module Metasploit::Pro::Report::ComplianceTests
  class PCITest
    include Metasploit::Pro::Report::Utils

    attr_accessor :xml_file, :report_config
    attr_reader :pci_results_summary, :pci_failures
    attr_reader :services, :hosts, :vulns, :creds

    # @param xml_file_path [String] Path to XML file where test results
    # are recorded for report consumption.
    # @param report_config [Hash]
    # @param allowed_addresses [Array<String>] Each allowed address,
    # expanded from included/excluded address selection/wildcards/CIDR,
    # etc.
    def initialize(xml_file_path, report_config, allowed_addresses)
      @xml_file = xml_file_path
      @report_config = report_config
      @allowed_addresses = allowed_addresses
      @pci_results_summary = {}
      @pci_failures = Set.new
      @workspace  = Mdm::Workspace.find(@report_config[:workspace_id])
      @hosts      = @workspace.hosts.where(address: @allowed_addresses)
      @services   = @hosts.collect {|h| h.services }.flatten
      @vulns      = @hosts.collect {|h| h.vulns }.flatten
    end

    # Currently tested PCI sections.
    # For more detailed descriptions, see https://www.pcisecuritystandards.org/documents/pci_dss_v2.pdf
    PCI_REQ_DESC = {
      '2.2.1'  => 'Implement only one primary function per server to prevent functions that require different security levels from co-existing on the same server. (For example, web servers, database servers, and DNS should be implemented on separate servers. http and https are considered the same service in this context.)',
      '2.3'    => 'Encrypt all non-console administrative access such as browser/Web-based management tools.',
      '6.2'    => 'Ensure that all system components and software are protected from known vulnerabilities by installing applicable vendor-supplied security patches. Install critical security patches within one month of release.',
      '8.2'    => 'Employ at least one of these to authenticate all users: password or passphrase; or two-factor authentication (e.g., token devices, smart cards, biometrics, public keys).',
      '8.2.1'    => 'Using strong cryptography, render all authentication credentials (such as passwords/phrases) unreadable during transmission and storage on all system components.',
      '8.2.3' => 'Passwords must require a minimum password length of at least seven characters and contain both numeric and alphabetic characters, or at least equivalent complexity and strength.',
      '8.5'  => 'Do not use group, shared, or generic accounts and passwords, or other authentication methods.'
    }

    def test
      reqs = PCI_REQ_DESC.keys.map {|i| i.gsub(".","_")}
      xml_results = File.open(@xml_file, 'w')

      xml_results.write %Q|<?xml version="1.0" encoding="UTF-8"?>\n|
      xml_results.write %Q|<MetasploitPCI32v1>\n|
      xml_results.write %Q|<product name="#{@report_config[:product_name]}" />\n|
      xml_results.write %Q|<logo>#{@report_config[:logo_path]}</logo>\n|
      xml_results.write %Q|<generated time="#{Time.now.utc}" user="#{@report_config[:report_username]}" project=#{Mdm::Workspace.find(@report_config[:workspace_id]).name.to_s.encode(xml: :attr)} />\n|

      xml_results.write %Q|<requirements>\n|
      # Results from each requirement
      reqs.each do |req|
        gen_pci_req_pre(xml_results, req)
        gen_pci_req(xml_results, req)
        gen_pci_req_post(xml_results, req)
      end
      xml_results.write %Q|</requirements>\n|

      # Convenience summaries
      generate_host_summary(xml_results)
      generate_test_summary(xml_results)
      generate_pci_reqs_summary(xml_results)
      generate_pci_results_summary(xml_results)

      # Closing tag
      xml_results.write %Q|</MetasploitPCI32v1>\n|
      xml_results.flush
      xml_results.close
    end

    def gen_pci_req_pre(result_file,req)
      num = req.gsub('_','.')
      desc = PCI_REQ_DESC[num]
      result_file.write %Q|<requirement number="#{num}">\n|
      result_file.write %Q|<description>#{desc}</description>\n|
      result_file.flush
    end
    def gen_pci_req_post(result_file,req)
      result_file.write %Q|</requirement>\n|
      result_file.flush
    end


    #
    # ----- Specific PCI Tests
    #

    # 2.2.1
    #
    # Requirement: Services providing functions requiring different security
    # levels should not be present on the same host.
    # Current: Listening services on hosts checked for hardcoded set of 'major'
    # services. Aside from http and https being allowed, other major
    # combinations are a failure.
    def test_pci_2_2_1
      hosts = {}
      @services.each do |svc|
        hosts[svc.host.address] ||= []
        next unless svc.state == "open" # Skip closed services
        next if hosts[svc.host.address].map {|s| s.name}.include? svc.name # Skip dupe services.
        if %w{http https dns ftp mysql postgres db2 mssql}.include? svc.name
          hosts[svc.host.address] << svc
        end
      end
      multihosts = []
      hosts.each_pair do |k,v|
        # http/https should be considered same svc
        apache_service = Set.new(['http', 'https'])
        actual_svcs = Set.new(v.map(&:name))
        if apache_service.subset? actual_svcs
          cnt = 2
        else
          cnt = 1
        end
        if v.size > cnt
          multihosts << [k,v]
          @pci_failures.add(k) # TODO
        end
      end
      ret = multihosts.empty?
      save_pci_results('2.2.1', ret)
      return ret,multihosts
    end


    # 2.3
    #
    # Requirement: Remote administrative access must be strongly encrypted.
    # Current: Looks for listening telnet and remote login services, as they are
    # not encrypted.
    # Not covered: additional web-based management interfaces, other
    # services (e.g. database services allowing remote access).
    def test_pci_2_3
      hosts = {}
      @services.each do |svc|
        hosts[svc.host.address] ||= []
        next unless svc.state == "open" # Skip closed services.
        if %w{telnet shell rexec rlogin}.include? svc.name
          hosts[svc.host.address] << svc
        end
        # Any listening http on a cisco device is bad news.
        if svc.name == "http" and svc.host.os_name =~ /cisco/i
          hosts[svc.host.address] << svc
        end
      end
      cleartext_services = []
      hosts.each_pair { |k,v|	(cleartext_services << [k,v]; @pci_failures.add(k)) if not v.empty? }
      ret = cleartext_services.empty?
      save_pci_results('2.3', ret)
      return ret,cleartext_services
    end

    # 6.2
    #
    # Requirement: Ensure that all system components and software are protected from known vulnerabilities by installing applicable vendor-
    # supplied security patches. Install critical security patches within one month of release.
    # Current: Looks for successful exploits that aren't from bruteforce.
    def test_pci_6_2
      hosts = {}
      failures = {}

      @vulns.each do |vuln|
        hosts[vuln.host.address] ||= []
        # Only need to check vulns related to successful, applicable exploit
        # modules (no auxiliary):
        exploit_modules_attempted = vuln.vuln_attempts.where(exploited: true).map(&:module).uniq
        exploit_modules_attempted - compliance_skippable_exploits
        next if exploit_modules_attempted.blank?
        next unless exploit_modules_attempted.grep /^exploit/

        hosts[vuln.host.address] << vuln.id
      end

      hosts.each_pair do |k,v|
        if !v.empty?
          failures[k] = v
          @pci_failures.add(k)
        end
      end

      passed = failures.empty?
      save_pci_results('6.2', passed)
      return passed, failures
    end

    # 8.2
    #
    # Requirement: To authenticate, all users must provide: something known
    # (e.g. password), something possessed (e.g. token device), and something
    # they are (i.e. biometric).
    # Current: Looks for blank passwords able to login.
    # Not covered: hashes indicating a blank password, other forms of
    # identification (e.g. RSA token).
    # @return [Boolean, Hash<String, Array>] the status of the
    # requirement check and {each host address => [credentials
    # failing the requirement]}
    def test_pci_8_2
      hosts = {}
      failures = {}

      @hosts.each do |host|
        hosts[host.address] = []
        cores = Metasploit::Credential::Core.originating_host_id(host.id).to_a.flatten
        cores.each do |core|
          next unless core.logins.where(status: Metasploit::Model::Login::Status::SUCCESSFUL).count > 0

          private = core.private
          if private
            if private.type =~ /Password/ && private.data.blank?
              hosts[host.address] << core
            end
          else
            hosts[host.address] << core
          end
        end
      end

      # For each host checked, verify if any failing creds were found
      hosts.each_pair do |k,v|
        if !v.empty?
          failures[k] = v
          @pci_failures.add(k)
        end
      end

      passed = failures.empty?
      save_pci_results('8.2', passed)
      return passed, failures
    end

    # 8.2.1
    #
    # Requirement: Using strong cryptography, render all authentication credentials (such as passwords/phrases) unreadable during transmission and storage on all system components.
    # Current: Looks for SSH private keys, SMB hashes, and plaintext
    # passwords related to validated logins.
    # Not covered: Encryption in transport.
    def test_pci_8_2_1
      hosts = {}
      failures = {}

      @hosts.each do |host|
        hosts[host.address] = []
        cores = Metasploit::Credential::Core.originating_host_id(host.id).to_a.flatten
        cores.each do |core|
          next unless core.logins.where(status: Metasploit::Model::Login::Status::SUCCESSFUL).count > 0

          private = core.private
          if private
            next if pci_8_2_1_skippable(core)
            hosts[host.address] << core
          end
        end
      end

      hosts.each_pair do |k,v|
        if !v.empty?
          failures[k] = v
          @pci_failures.add(k)
        end
      end

      passed = failures.empty?
      save_pci_results('8.2.1', passed)
      return passed, failures
    end

    # 8.2.1 related
    #
    # @param core [Metasploit::Credential::Core] to be checked: has a
    # `Metasploit::Credential::Password` private and a
    # `Metasploit::Credential::Origin::Service`, skipped if related to a
    # service that encrypts.
    # @return [Boolean] if core is skippable
    def pci_8_2_1_skippable(core)
      origin = core.origin
      if core.private.type =~ /Password/ && core.origin_type =~ /Service/
        encrypted_svcs = ['ssh', 'https']
        origin.service && (encrypted_svcs.member? origin.service.name)
      end
    end

    # 8.2.3
    #
    # Requirement: Passwords must require a minimum password length of
    # at least seven characters and contain both numeric and alphabetic characters.
    # Current: Looks for plaintext passwords able to login that are
    # under seven characters long and dont have one letter or one number
    # Not covered: hashes indicating a blank password.
    def test_pci_8_2_3
      hosts = {}
      failures = {}

      @hosts.each do |host|
        hosts[host.address] = []
        cores = Metasploit::Credential::Core.originating_host_id(host.id).to_a.flatten
        cores.each do |core|
          next unless core.logins.where(status: Metasploit::Model::Login::Status::SUCCESSFUL).count > 0

          private = core.private
          if private
            next unless core.private.type =~ /Password/ && (private.data.length < 7 || !alphanumeric(private.data))
            hosts[host.address] << core
          else
            # No private is a failure too:
            hosts[host.address] << core
          end
        end
      end

      hosts.each_pair do |k,v|
        if !v.empty?
          failures[k] = v
          @pci_failures.add(k)
        end
      end

      passed = failures.empty?
      save_pci_results('8.2.3', passed)
      return passed, failures
    end

    # 8.5
    #
    # Requirement: Do not use group, shared, or generic accounts and passwords, or other authentication methods.
    # Current: Compares publics related to validated logins to a set of
    # generic usernames.
    # Not covered: Usernames and privates actually shared between hosts
    # and services.
    def test_pci_8_5
      hosts = {}
      failures = {}

      @hosts.each do |host|
        hosts[host.address] = []
        cores = Metasploit::Credential::Core.originating_host_id(host.id).to_a.flatten
        cores.each do |core|
          next unless core.logins.where(status: Metasploit::Model::Login::Status::SUCCESSFUL).count > 0

          public = core.public
          if public
            next unless generic_user? core.public.username
            hosts[host.address] << core
          end
        end
      end

      hosts.each_pair do |k,v|
        if !v.empty?
          failures[k] = v
          @pci_failures.add(k)
        end
      end

      passed = failures.empty?
      save_pci_results('8.5', passed)
      return passed, failures
    end

    # ----- END Specific PCI Tests


    #
    # ----- Utils
    #

    # Verifies that a string contains letters AND numbers.
    # @param string [String] to be checked
    # @return [Boolean] if the string passes
    def alphanumeric(string)
      if (string[/[A-Za-z]/] && string[/[0-9]/])
        true
      else
        false
      end
    end

    # Wrapper for calling each requirement test method and adding the
    # results to the XML file.
    # @param result_file [File] to append results to
    # @param req [String] X_X format of requirement being tested
    def gen_pci_req(result_file, req)
      service_related =    ['2_2_1', '2_3']
      exploit_related =    ['6_2']
      credential_related = ['8_2', '8_2_1', '8_2_3', '8_5']

      req_passed, data = self.send("test_pci_#{req}")
      result_file.write %Q|<result status="#{req_passed ? 'pass' : 'fail'}">\n|
      if service_related.member? req
        gen_pci_results_service(result_file, data) unless req_passed
      elsif exploit_related.member? req
        gen_pci_results_exploit(result_file, data) unless req_passed
      elsif credential_related.member? req
        gen_pci_results_credential(result_file, data) unless req_passed
      end
      result_file.write %Q|</result>\n|
      result_file.flush
    end

    # This writes the XML for tests that enumerate services.
    def gen_pci_results_service(report_file, data)
      report_file.write %Q|<details>\n|
      report_file.write %Q|<hosts>\n|
      data.each do |host, svc|
        this_host = @hosts.select {|h| h.address == host}.first
        report_file.write %Q|<host address="#{this_host.address}">\n|
        report_file.write %Q|#{create_xml_element('name', this_host.name)}\n|
        report_file.write %Q|<os>#{[this_host.os_name, this_host.os_flavor, this_host.os_sp].join(" ")}</os>\n|
        report_file.write %Q|<services>\n|
        svc.each do |s|
          report_file.write %Q|<service>\n|
          report_file.write %Q|<name>#{s.name}</name>\n|
          report_file.write %Q|<port>#{s.port}</port>\n|
          report_file.write %Q|<protocol>#{s.proto}</protocol>\n|
          report_file.write %Q|</service>\n|
        end
        report_file.write %Q|</services>\n|
        report_file.write %Q|</host>\n|
      end
      report_file.write %Q|</hosts>\n|
      report_file.write %Q|</details>\n|
    end

    # Wraps recording of a given test's result.
    # @param requirement [String] X.X format of requirement whose result
    # is being recorded
    # @param result [Boolean] status of test
    def save_pci_results(requirement, result)
      @pci_results_summary[requirement] = (result ? "PASS" : "FAIL")
    end

    def gen_pci_results_exploit(report_file, data)
      report_file.write %Q|<details>\n|
      report_file.write %Q|<hosts>\n|
      data.each do |host, vuln_ids|
        this_host = @hosts.select {|h| h.address == host}.first
        report_file.write %Q|<host address="#{this_host.address}">\n|
        report_file.write %Q|#{create_xml_element('name', this_host.name)}\n|
        report_file.write %Q|<os>#{[this_host.os_name, this_host.os_flavor, this_host.os_sp].join(" ")}</os>\n|
        report_file.write %Q|<vulns>\n|
        vuln_ids.each do |vid|
          vuln = Mdm::Vuln.find(vid)
          exploit_modules = vuln.vuln_attempts.where(exploited: true).map(&:module).uniq

          report_file.write %Q|<vuln>\n|
          report_file.write %Q|#{create_xml_element('name', vuln.name)}\n|
          report_file.write %Q|#{create_xml_element('exploited_at', vuln.exploited_at)}\n|
          report_file.write %Q|#{create_xml_element('module', exploit_modules.join(', '))}\n|
          report_file.write %Q|</vuln>\n|
        end
        report_file.write %Q|</vulns>\n|
        report_file.write %Q|</host>\n|
      end
      report_file.write %Q|</hosts>\n|
      report_file.write %Q|</details>\n|
    end

    # TODO This is a terrible method. It is long and winding.
    # Refactor needed: break into sensible components or use some ERB.
    # There are more very similar to it, DRY them!
    #
    # Currently it adds credential-related test results as XML. Mostly
    # related to details of failures, adding in related data for the
    # report to consume.
    # @param report_file [File] to append results to
    # @param data [Hash<String,Array>] each host address => test failures
    # @return [File] the open, unflushed File with results added
    def gen_pci_results_credential(report_file, data)
      mask_creds = report_config['mask_credentials']
      report_file.write %Q|<details>\n|
      report_file.write %Q|<hosts>\n|
      data.each_pair do |host_addr, credentials|
        host = @hosts.select {|h| h.address == host_addr }.first
        report_file.write %Q|<host address="#{host.address}">\n|
        report_file.write %Q|<name>#{host.name}</name>\n|
        os_string = [host.os_name, host.os_flavor, host.os_sp].compact.join(" ")
        report_file.write %Q|<os>#{os_string}</os>\n|
        report_file.write %Q|<credentials>\n|
        credentials.each do |c|
          report_file.write %Q|<credential>\n|
          if c.public
            user = c.public.username
          else
            user = '*BLANK*'
          end
          report_file.write %Q|#{create_xml_element('public', user)}\n|

          if c.private
            tag = pretty_private_type(c.private.type.split('::')[-1])
            private = mask_cred(c.private.data, mask_creds)
            report_file.write %Q|#{create_xml_element('private_type', tag)}\n|
            report_file.write %Q|#{create_xml_element('private', private)}\n|
          end

          # Origin-specific details
          origin = c.origin_type.split('::')[-1]
          report_file.write %Q|<origin>\n|
          case origin
          when 'Session'
            detail = c.origin.post_reference_name
          when /Service|Login/
            service_name = c.origin.service.name
            service_port = c.origin.service.port
            service_proto = c.origin.service.proto
            svc_detail = service_proto ? "#{service_port}/#{service_proto}" : service_port
            detail = "#{service_name} (#{svc_detail})"
          end
          report_file.write %Q|#{create_xml_element('type', origin)}\n|
          report_file.write %Q|#{create_xml_element('detail', detail)}\n|

          report_file.write %Q|</origin>\n|

          report_file.write %Q|</credential>\n|
        end
        report_file.write %Q|</credentials>\n|
        report_file.write %Q|</host>\n|
      end
      report_file.write %Q|</hosts>\n|
      report_file.write %Q|</details>\n|
    end

    def create_xml_element(name,data)
      "<#{name}>#{data}</#{name}>"
    end

    # Hosts that were tested -- sorted by IP
    def generate_host_summary(report_file)
      report_file.write %Q|<plaintext-host-summary>|
      addresses_names = {}
      @hosts.each {|h| addresses_names[h.address] = h.name}
      # Sort by IP address, include hostname
      sorted_addresses_names = Hash[addresses_names.sort_by {|ip, add| ip.split('.').map{ |octet| octet.to_i} }]
      # Write out IP address, (hostname) if available
      sorted_addresses_names.each { |a,n| report_file.write "#{a}#{(' (' + n + ')') if n && n != ''}\n" }
      report_file.write %Q|</plaintext-host-summary>\n|
    end

    # Status of hosts, whether they failed any requirement -- sorted by IP
    def generate_test_summary(report_file)
      report_file.write %Q|<plaintext-test-summary>|
      all_addresses = Set.new
      @hosts.each{|h| all_addresses.add(h.address)}
      if all_addresses == @pci_failures
        @pci_failures.each {|h| report_file.write "FAIL\n"}
      else
        # Compare failing hosts with all hosts, set pass/fail, sort
        results = {}
        all_addresses.each {|h| results[h] = "PASS" }
        @pci_failures.each {|h| results[h] = "FAIL" }
        sorted_results = Hash[results.sort_by {|ip, res| ip.split('.').map{ |octet| octet.to_i} }]
        sorted_results.each {|a, r| report_file.write "#{r}\n" }
      end
      report_file.write %Q|</plaintext-test-summary>\n|
    end

    # List of PCI requirement numbers covered
    def generate_pci_reqs_summary(report_file)
      report_file.write %Q|<plaintext-pci-reqs>|
      @pci_results_summary.each_pair do |reqnum,reqres|
        report_file.write "#{reqnum}\n"
      end
      report_file.write %Q|</plaintext-pci-reqs>\n|
    end

    # Test results per req number
    def generate_pci_results_summary(report_file)
      report_file.write %Q|<plaintext-pci-results>|
      @pci_results_summary.each_pair do |reqnum,reqres|
        report_file.write "#{reqres}\n"
      end
      report_file.write %Q|</plaintext-pci-results>\n|
      report_file.flush
    end

    # ----- END Utils

  end
end

