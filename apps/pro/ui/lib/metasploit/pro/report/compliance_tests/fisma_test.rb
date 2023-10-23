module Metasploit::Pro::Report::ComplianceTests
  class FISMATest
    include Metasploit::Pro::Report::Utils
    include Msf::Pro::Locations

    def self.locations
      @_locations ||= Object.new.extend(Msf::Pro::Locations)
    end
    # END mess

    attr_accessor :xml_file, :report_config
    attr_reader :fisma_results_summary
    attr_reader :services, :hosts, :vulns, :creds

    def initialize(xml_file_path, report_config, allowed_addresses)
      @xml_file = xml_file_path
      @report_config = report_config
      @allowed_addresses = allowed_addresses
      @fisma_results_summary = {}
      @workspace = Mdm::Workspace.find(@report_config[:workspace_id])
      @hosts     = @workspace.hosts.where(address: @allowed_addresses)
      @services  = @hosts.collect {|h| h.services }.flatten
      @vulns     = @hosts.collect {|h| h.vulns }.flatten
    end

    # FISMA requirements and descriptions
    # For more details, see http://www.fismapedia.org/index.php?title=Doc:NIST_SP_800-53r3_Appendix_F
    FISMA_REQ_DESC = {
      # Parent sections dropped due to not actually testing anything:
      #  AC-1, AT-1, IA-1, SI-1, CM-1
      # TODO Dropped in 4.10 (ineffective coverage of control):
      #  AC-4, AC-6, AC-10; AT-3; CM-5; IA-8; SI-3, SI-7, SI-8, SI-9
      'AC-7'  => "The information system: (a) Enforces a limit of [Assignment: organization-defined number] consecutive invalid login attempts by a user during a [Assignment: organization-defined time period]; and (b) Automatically [Selection: locks the account/node for an [Assignment: organization-defined time period]; locks the account/node until released by an administrator; delays next login prompt according to [Assignment: organization-defined delay algorithm]] when the maximum number of unsuccessful attempts is exceeded. The control applies regardless of whether the login occurs via a local or network connection.",
      'AT-2'  => "The organization provides basic security awareness training to all information system users (including managers, senior executives, and contractors) as part of initial training for new users, when required by system changes, and [Assignment: organization-defined frequency] thereafter.",
      'CM-7'  => "The organization configures the information system to provide only essential capabilities and specifically prohibits or restricts the use of the following functions, ports, protocols, and/or services: [Assignment: organization-defined list of prohibited or restricted functions, ports, protocols, and/or services].",
      'IA-2'  => "The information system uniquely identifies and authenticates organizational users (or processes acting on behalf of organizational users).",
      'IA-5'  => "The organization manages information system authenticators for users and devices by: (a) Verifying, as part of the initial authenticator distribution, the identity of the individual and/or device receiving the authenticator; (b) Establishing initial authenticator content for authenticators defined by the organization; (c) Ensuring that authenticators have sufficient strength of mechanism for their intended use; (d) Establishing and implementing administrative procedures for initial authenticator distribution, for lost/compromised or damaged authenticators, and for revoking authenticators; (e) Changing default content of authenticators upon information system installation; (f) Establishing minimum and maximum lifetime restrictions and reuse conditions for authenticators (if appropriate); (g) Changing/refreshing authenticators [Assignment: organization-defined time period by authenticator type]; (h) Protecting authenticator content from unauthorized disclosure and modification; and (i) Requiring users to take, and having devices implement, specific measures to safeguard authenticators.",
      'IA-7'  => "The information system uses mechanisms for authentication to a cryptographic module that meet the requirements of applicable federal laws, Executive Orders, directives, policies, regulations, standards, and guidance for such authentication.",
      'RA-5'  => "The organization: (a) Scans for vulnerabilities in the information system and hosted applications [Assignment: organization-defined frequency and/or randomly in accordance with organization-defined process] and when new vulnerabilities potentially affecting the system/applications are identified and reported; (b) Employs vulnerability scanning tools and techniques that promote interoperability among tools and automate parts of the vulnerability management process by using standards for: (b-1) Enumerating platforms, software flaws, and improper configurations; (b-2) Formatting and making transparent, checklists and test procedures; and (b-3) Measuring vulnerability impact; (c) Analyzes vulnerability scan reports and results from security control assessments; (d) Remediates legitimate vulnerabilities [Assignment: organization-defined response times] in accordance with an organizational assessment of risk; and (e) Shares information obtained from the vulnerability scanning process and security control assessments with designated personnel throughout the organization to help eliminate similar vulnerabilities in other information systems (i.e., systemic weaknesses or deficiencies).",
      'SI-2'  => "The organization: (a) Identifies, reports, and corrects information system flaws; (b) Tests software updates related to flaw remediation for effectiveness and potential side effects on organizational information systems before installation; and (c) Incorporates flaw remediation into the organizational configuration management process.",
      'SI-10' => "The information system checks the validity of information inputs.",
    }

    def test
      reqs = FISMA_REQ_DESC.keys
      xml_results = File.open(@xml_file, 'w')

      xml_results.write %Q|<?xml version="1.0" encoding="UTF-8"?>\n|
      xml_results.write %Q|<MetasploitFISMAr3v1>\n|
      xml_results.write %Q|<product name="#{@report_config[:product_name]}" />\n|
      xml_results.write %Q|<logo>#{@report_config[:logo_path]}</logo>\n|
      xml_results.write %Q|<generated time="#{Time.now.utc}" user="#{@report_config[:report_username]}" project=#{@workspace.name.to_s.encode(xml: :attr)} />\n|

      xml_results.write %Q|<requirements>\n|
      # Results from each requirement
      reqs.each do |req|
        gen_fisma_req_pre(xml_results, req)
        gen_fisma_req(xml_results, req)
        gen_fisma_req_post(xml_results, req)
      end
      xml_results.write %Q|</requirements>\n|

      # Convenience summaries
      generate_fisma_reqs_summary(xml_results)
      generate_fisma_results_summary(xml_results)

      # Closing tag
      xml_results.write %Q|</MetasploitFISMAr3v1>\n|
      xml_results.flush
      xml_results.close
    end

    def gen_fisma_req_pre(result_file, req)
      desc = FISMA_REQ_DESC[req]
      result_file.write %Q|<requirement control="#{req}">\n|
      result_file.write %Q|<description>#{desc}</description>\n|
      result_file.flush
    end

    def gen_fisma_req_post(result_file, req)
      result_file.write %Q|</requirement>\n|
      result_file.flush
    end

    # ----- Specific FISMA Tests

    # AC-7
    #
    # Actual: A limit is placed on the number of consecutive invalid
    # login attempts by a user in a time period. Access to the host is
    # delayed or locked out after this is reached.
    # Current: Number of failed logins per public per host checked, if more
    # than the set rate (reasonable guess only, this is a per-organization
    # threshold in reality) this fails.
    def test_fisma_ac7
      # Invalid attempts allowed per time_limit before lockout
      max_count  = 3
      time_limit = 60 # seconds

      hosts = {}
      failures = {}

      @hosts.each do |host|
        hosts[host.address] = []
        host_id = host.id

        publics_logins = Metasploit::Credential::Login.failed_logins_by_public(host_id)

        # For each tried, failed, non-locked out login, see how many
        # other such logins there are within the time limit starting
        # from the login's last attempt time. If this is ever more
        # than the max then the test fails as they should have been
        # locked out.
        publics_logins.each_pair do |username, logins|
          next unless logins.count >= max_count

          logins.each do |l|
            attempt = l.last_attempted_at.to_time
            overlap = attempt..(attempt + time_limit)

            subsequent_logins = logins - [l]
            # TODO Do this in a less silly way:
            subsequent_logins = Metasploit::Credential::Login.where("id IN (#{subsequent_logins.map(&:id).join(',')})")

            overlapping = subsequent_logins.where(last_attempted_at: overlap)
            if overlapping.count > max_count
              hosts[host.address] << l.core
              break # No need to look at remaining logins once the core fails
            end
          end

        end
      end # hosts

      # For each host checked, verify if any failing creds were found
      hosts.each_pair do |k,v|
        if !v.empty?
          failures[k] = v
        end
      end
      passed = failures.empty?
      return passed, failures
    end

    # AT-2
    #
    # Actual: The organization provides security awareness training
    # to new users and when the system changes.
    # Current: Check for exploitable vulns.
    # TODO: SE campaigns in the workspace with form submissions. This
    # will require more significant template updates as it isn't
    # host-specific.
    def test_fisma_at2
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
        end
      end

      passed = failures.empty?
      return passed, failures
    end

    # CM-7
    #
    # Actual: Only essential capabilities should be provided by each
    # host. Uses a per-organization banned list of protocols, ports,
    # services.
    # Current: Hosts running more than one major service fail.
    # TODO: Consider adding Network Segmentation MM results, but would
    # be difficult to pick what open results are not acceptable per org.
    def test_fisma_cm7
      hosts = {}
      @services.each do |svc|
        hosts[svc.host.address] ||= []
        next unless svc.state == "open" # Skip closed services.
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
        end
      end
      ret = multihosts.empty?
      return ret,multihosts
    end

    # IA-2
    #
    # Actual: System uniquely identifies and authenticates
    # organizational users. Check for group accounts, verify private
    # in place.
    # Current: Verify private in place for all cores related to
    # validated logins. Public must also be in place, and not a
    # common username.
    # TODO Check for shared publics, shared privates, other private
    # types (e.g. NTLM hashes being present (and replayable) could count
    # as lack of private).
    def test_fisma_ia2
      hosts = {}
      failures = {}

      @hosts.each do |host|
        hosts[host.address] = []
        cores = Metasploit::Credential::Core.originating_host_id(host.id).to_a.flatten
        cores.each do |core|
          next unless core.logins.where(status: Metasploit::Model::Login::Status::SUCCESSFUL).count > 0
          failing = false

          private = core.private
          if private
            if private.type =~ /Password/ && private.data.blank?
              failing = true
            end
          else
            failing = true
          end

          public = core.public
          if public
            if generic_user? core.public.username
              failing = true
            end
          else
            failing = true
          end

          if failing
            hosts[host.address] << core
          end
        end
      end

      # For each host checked, verify if any failing creds were found
      hosts.each_pair do |k,v|
        if !v.empty?
          failures[k] = v
        end
      end
      passed = failures.empty?
      return passed, failures
    end

    # IA-5
    #
    # Actual: Identity of users receiving authenticators is verified,
    # authenticators checked for required strength, lifetime and re-use
    # conditions on authenticators, regular refreshing of authenticators,
    # individuals and devices have specific safeguards to protect
    # authenticators, group accounts changed when membership changes.
    # Current: Runs IA-2.
    # TODO: Check password length and complexity.
    def test_fisma_ia5
      test_fisma_ia2
    end

    # IA-7
    #
    # Actual: Authentication uses acceptable cryptographic protection.
    # Current: Open plaintext auth services and http on a Cisco device
    # results in a failure.
    def test_fisma_ia7
      hosts = {}
      @services.each do |svc|
        hosts[svc.host.address] ||= []
        next unless svc.state == "open" # Skip closed services.
        if %w{telnet shell rexec rlogin pop3}.include? svc.name
          hosts[svc.host.address] << svc
        end
        # Any listening http on a cisco device is bad news.
        if svc.name == "http" and svc.host.os_name =~ /cisco/i
          hosts[svc.host.address] << svc
        end
      end
      cleartext_services = []
      hosts.each_pair { |k,v|	cleartext_services << [k,v] if not v.empty? }
      ret = cleartext_services.empty?
      return ret,cleartext_services
    end

    # RA-5
    #
    # Actual: The organization scans for vulnerabilities regularly and
    # when new potential vulnerabilities are announced. Scanning tools
    # should be used, reports should be analyzed, legitimate vulns
    # should be patched within a determined timeframe.
    # Current: Runs AT-2 (checks for any exploitable vulns)
    def test_fisma_ra5
      test_fisma_at2
    end

    # SI-2
    #
    # Actual: System flaws are identified and corrected. Updates are
    # tested for effectiveness and side effects, flaw remediation is
    # incorporated into the config management process.
    # Current: Runs AT-2 (checks for any exploitable vulns)
    def test_fisma_si2
      test_fisma_at2
    end

    # SI-10
    #
    # Actual: Validity of inputs is checked.
    # Current: Runs AT-2 (checks for any exploitable vulns)
    # TODO: Should check for SQL injection vulns explicitly, potentially
    # others.
    def test_fisma_si10
      test_fisma_at2
    end

    # ----- END Specific FISMA Tests


    # ----- Utils

    # Wrapper for calling each requirement test method and adding the
    # results to the XML file.
    # @param result_file [File] to append results to
    # @param req [String] XX-XX format of requirement being tested
    def gen_fisma_req(result_file, req)
      credential_related = %w|AC-7 IA-2 IA-5|
      service_related    = %w|CM-7 IA-7|
      exploit_related    = %w|AT-2 RA-5 SI-2 SI-10|

      cleaned_req = req.gsub('-', '').downcase
      req_passed, data = self.send("test_fisma_#{cleaned_req}")
      save_fisma_results(req, req_passed)

      result_file.write %Q|<result status="#{req_passed ? 'pass' : 'fail'}">\n|
      if service_related.member? req
        gen_fisma_results_service(result_file, data) unless req_passed
      elsif exploit_related.member? req
        gen_fisma_results_exploit(result_file, data) unless req_passed
      elsif credential_related.member? req
        gen_fisma_results_credential(result_file, data) unless req_passed
      end
      result_file.write %Q|</result>\n|
      result_file.flush
    end

    # Wraps recording of a given test's result.
    # @param requirement [String] XX-XX format of requirement whose result
    # is being recorded
    # @param result [Boolean] status of test
    def save_fisma_results(requirement, result)
      @fisma_results_summary[requirement] = (result ? 'PASS' : 'FAIL')
    end

    def create_xml_element(name,data)
      if data
        "<#{name}>#{data}</#{name}>"
      else
        "<#{name}/>"
      end
    end

    # List of FISMA requirement numbers covered
    def generate_fisma_reqs_summary(report_file)
      report_file.write %Q|<plaintext-fisma-reqs>\n|
      report_file.write "FISMA Requirement\n"
      @fisma_results_summary.each_pair do |req, reqres|
        report_file.write "#{req}\n"
      end
      report_file.write %Q|</plaintext-fisma-reqs>\n|
    end

    # Test results per req number
    def generate_fisma_results_summary(report_file)
      report_file.write %Q|<plaintext-fisma-results>\n|
      report_file.write "Result\n"
      @fisma_results_summary.each_pair do |req,reqres|
        report_file.write "#{reqres}\n"
      end
      report_file.write %Q|</plaintext-fisma-results>\n|
      report_file.flush
    end

    # Lists all successful exploits
    def gen_fisma_results_exploit(report_file, data)
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

    # Lists all offending services
    def gen_fisma_results_service(report_file, data)
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

    # Adds credential-related test results as XML.
    # @param report_file [File] to append results to
    # @param data [Hash<String,Array>] each host address => test failures
    # @return [File] the open, unflushed File with results added
    def gen_fisma_results_credential(report_file, data)
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

    # ----- END Utils

  end
end


