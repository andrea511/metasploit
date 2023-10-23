module Msf

  module Pro::MetaOptions

    # default stub
    def port_allowed?(_rport)
      true
    end

    # Create a mapping table of ports, refs, services to modules. The strategy is exploit-wise.
    # First, create the (exploit or auxiliary) module. Skip if it's not at least @minrank. Record
    # the references (CVE's et al) in a local mrefs hash, the target ports in a local mports hash,
    # and target services in the local mservs hash. Once that's all done, move these three hashes
    # to instance variables @module_xrefs, @module_ports, and @module_servs. FIXME: This should
    # be broken up into discrete steps for easier testing/troubleshooting.
    #
    # Note that opts is set explicitly by the run() task -- there appears to be no way for the
    # user to influence these choices.
    def create_exploit_maps(opts={})
      opt_xrefs = opts[:match_references]
      opt_ports = opts[:match_ports]

      opt_module_filter = opts[:module_filter]

      mrefs  = {}
      mports = {}
      mservs = {}

      framework.db.workspace = myworkspace
      each_exploit(:fullname_or_refname => opt_module_filter, :minrank => @minrank) do |mod_detail|
        begin
          exploit = framework.exploits.create(mod_detail.refname)
        rescue NoMethodError => _e
          print_error("Error creating module: #{mod_detail.fullname}")
        end
        if (not exploit)
          print_error("Failed to create #{mod_detail.fullname}")
          next
        end

        if (opt_xrefs)
          exploit.references.each do |reference|
            next if reference.ctx_id == 'URL'
            ref = reference.ctx_id + "-" + reference.ctx_val.to_s
            ref.upcase!

            mrefs[ref]                   ||= {}
            mrefs[ref][exploit.fullname] = exploit
          end
        end

        if (opt_ports)
          if (exploit.datastore['RPORT'] and port_allowed?(exploit.datastore['RPORT']))
            rport                                = exploit.datastore['RPORT']
            mports[rport.to_i]                   ||= {}
            mports[rport.to_i][exploit.fullname] = exploit
          end

          if (exploit.respond_to?('autofilter_ports'))
            exploit.autofilter_ports.each do |rport|
              next unless port_allowed?(rport)
              mports[rport.to_i]                   ||= {}
              mports[rport.to_i][exploit.fullname] = exploit
            end
          end

          if (exploit.respond_to?('autofilter_services'))
            exploit.autofilter_services.each do |serv|
              mservs[serv]                   ||= {}
              mservs[serv][exploit.fullname] = exploit
            end
          end
        end

      end

      # Store the mapping table in instance variables
      return mrefs, mports, mservs
    end

    # Yields all Mdm::Module::Details that are an aggressive exploit with a
    # default target that match the given options.
    #
    # @param options [Hash{Symbol => Object}]
    # @option options [String, Array<String>] :fullname_or_refname the exact
    #   Mdm::Module::Detail#fullnames and/or Mdm::Module::Detail#refnames for the
    #   exploit modules.
    # @option options [Integer] :minrank (0) Mdm::Module::Detail#rank must be
    #   `>=` this value.
    # @yield [module_detail]
    # @yieldparam module_detail [Mdm::Module::Detail] module that matches the
    #   given filters.
    # @yieldreturn [void]
    # @return [void]
    def each_exploit(options={}, &block)
      options.assert_valid_keys(:fullname_or_refname, :minrank)

      fullname_or_refname = options[:fullname_or_refname]

      query = Mdm::Module::Detail.where(
          :mtype  => 'exploit',
          :stance => 'aggressive'
      )

      module_details = Mdm::Module::Detail.arel_table

      minrank = options[:minrank]

      if minrank
        query = query.where(
            module_details[:rank].gteq(minrank)
        )
      end

      query = query.where(
          module_details[:default_target].not_eq(nil),
      )

      if fullname_or_refname.present?
        query = query.where(
            module_details[:fullname].in(fullname_or_refname).or(
                module_details[:refname].in(fullname_or_refname)
            )
        )
      end

      query.find_each(:batch_size => 500, &block)
    end

    # Tests for various service conditions by comparing the module's fullname (which
    # is basically a pathname) to the intended target service record. The service.info
    # column is tested against a regex in most/all cases and "false" is returned in the
    # event of a match between an incompatible module and service fingerprint.
    def exploit_filter_by_service(mod, serv)

      # Filter out Unix vs Windows exploits for SMB services
      return true if (mod.fullname =~ /\/samba/ and serv.info.to_s =~ /windows/i)
      return true if (mod.fullname =~ /\/windows/ and serv.info.to_s =~ /samba|unix|vxworks|qnx|netware/i)
      return true if (mod.fullname =~ /\/netware/ and serv.info.to_s =~ /samba|unix|vxworks|qnx/i)

      # Filter out IIS exploits for non-Microsoft services
      return true if (mod.fullname =~ /\/iis\/|\/isapi\// and (serv.info.to_s !~ /microsoft|asp/i))

      # Filter out Apache exploits for non-Apache services
      return true if (mod.fullname =~ /\/apache/ and serv.info.to_s !~ /apache|ibm/i)

      false
    end

    # Determines if an exploit (mod, an instantiated module) is suitable for the host (host)
    # defined operating system. Returns true if the host.os isn't defined, if the module's target
    # OS isn't defined, if the module's OS is "unix" and the host's OS is not "windows," or
    # if the module's target is "php." Or, of course, in the event the host.os actually matches.
    # This is a fail-open gate; if there's a doubt, assume the module will work on this target.
    def exploit_matches_host_os(mod, host)
      hos = host.os_name
      return true if not hos
      return true if hos.length == 0

      set = mod.platform.platforms.map { |x| x.to_s.split('::')[-1].downcase }
      return true if set.length == 0

      # Special cases
      return true if set.include?("unix") and hos !~ /windows/i

      # Skip archaic old HPUX bugs if we have a solid match against another OS
      if set.include?("unix") and set.include?("hpux") and mod.refname.index("hpux") and hos =~ /linux|irix|solaris|aix|bsd/i
        return false
      end

      # Skip AIX bugs if we have a solid match against another OS
      if set.include?("unix") and set.include?("aix") and mod.refname.index("aix") and hos =~ /linux|irix|solaris|hpux|bsd/i
        return false
      end

      # Skip IRIX bugs if we have a solid match against another OS
      if set.include?("unix") and set.include?("irix") and mod.refname.index("irix") and hos =~ /linux|solaris|hpux|aix|bsd/i
        return false
      end

      return true if set.include?("php")

      set.each do |mos|
        return true if hos.downcase.index(mos)
      end

      vprint_debug("Exploit #{mod.fullname} (#{set.join(", ")}) does not match #{host.address} (#{host.os_name})")
      false
    end

    # Determines if the given exploit (mod) is filtered, going by the exploit's
    # autofilter() method. Note this catches all exceptions.
    def exploit_is_filtered(mod, xhost, xport = nil)

      # Set the module's datastore target host information
      mod.datastore['RPORT'] = xport if xport
      mod.datastore['RHOST'] = xhost

      begin
        ::Timeout.timeout(2, ::RuntimeError) do
          return true if not mod.autofilter()
        end
      rescue ::Interrupt
        raise $!
      rescue ::Timeout::Error
        return true
      rescue ::Exception
        return true
      end

      false
    end

  end

end
