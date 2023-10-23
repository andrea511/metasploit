#
# -- XML Export
#
# TODO
# There are notable lacunae currently, e.g. Social Engineering data,
# which should be corrected by a generic extraction approach for
# defined objects of interest. A similar generic approach will
# be needed on the import side as well.
#
module Metasploit::Pro::Export::Type::Xml

  XML_EXPORT_VERSION = 'MetasploitV4'

  def description
    'An XML file describing, in most cases, all attributes of all
important objects in the project. This is suitable for import
into Metasploit instances, backups, and for further data analysis.'
  end
  module_function :description

  def pretty_name
    'XML'
  end
  module_function :pretty_name


  # Wrapper for all steps of an XML export.
  #
  # The XML generation writes outer open and close tags
  # manually versus with Nokogiri to conserve memory during creation.
  # Delegate methods handle generating each section with
  # Nokogiri. File is flushed to disk after each section,
  # written to disk at end.
  #
  # During the recent refactor of the export code (2013Q3/4), Nokogiri
  # was adopted to generate most of the XML wrapped in this method.
  # Before this, empty elements were represented as open and close tags
  # with no value (e.g. <host_details>\n</host_details>).
  # Nokogiri follows the W3C XML spec
  # (http://www.w3.org/TR/2008/REC-xml-20081126/#sec-starttags) in using
  # self-closing tags (e.g. <host_details/>) for empty elements.
  # A side benefit of this change is a reduction in file size
  # (and thus import time).
  def generate_xml_export
    self.prepare!
    xml_path = self.file_path

    self.generate!
    generate_xml_export_file(xml_path)

    self.cleanup!
    self.complete!
    logger.info "#{self.etype.pretty_name} export completed in #{export_duration.round(3)}s"
  end

  # Writes all parts of XML export file
  # @param xml_path [String] to which XML file is written
  # @param filesystem_data_dir [String] if filesystem-dependent sections
  # should be included in the XML, this is the parent dir to copy into
  def generate_xml_export_file(xml_path, filesystem_data_dir = nil)
    xml_file = File.open(xml_path, 'w')

    xml_file.write("<?xml version='1.0' encoding='UTF-8'?>\n")
    xml_file.write("<#{XML_EXPORT_VERSION}>\n")
    add_generated(xml_file)

    # Add each section:
    # Delegates passed open file, section generated,
    # written to file, file flushed:
    logger.debug("Adding export sections:")
    logger.debug("Adding hosts...")
    add_hosts(xml_file)
    logger.debug("Adding services...")
    add_services(xml_file, self.workspace)
    logger.debug("Adding sessions...")
    add_sessions(xml_file, self.workspace)
    logger.debug("Adding credentials...")
    add_credentials(xml_file, self.workspace)
    logger.debug("Adding events...")
    add_events(xml_file)
    logger.debug("Adding web data...")
    # Populated with allowed sites during add_web_sites,
    # used as recordset for subsequent web sections:
    @web_sites = []
    add_web_sites(xml_file)
    add_web_pages(xml_file)
    add_web_forms(xml_file)
    add_web_vulns(xml_file)
    # <module_details> is no longer added. This used to be exported from
    # the various module_{details,authers,refs,archs,platforms,targets,
    # actions,mixins} tables, but it was never imported. It also
    # was only metadata for Metasploit itself, not any user-generated
    # data.
    # It's entirely moot now since the module caching updates will
    # generate this information at boot.
    #
    # TODO Create generic approach to add new objects deemed important.

    # If data stored on the filesystem will be included, generate
    # sections for them:
    if filesystem_data_dir
      Export::FILESYSTEM_DEPENDENT.each do |obj|
        logger.debug("Adding #{obj}...")
        method("add_#{obj}").call(xml_file, "#{filesystem_data_dir}")
      end
    end

    xml_file.write("</#{XML_EXPORT_VERSION}>\n")
    xml_file.close
  end

  # Writes <generated /> element
  # @param xml_file [File] open XML file
  # @return [Boolean] whether fragment generation and cleanup was successful
  def add_generated(xml_file)
    now = Time.now.utc
    user = self.created_by
    # Old implementation used: workspace.name.gsub(/[^A-Za-z0-9\x20]/,"_")
    # Not sure why this was necessary
    workspace = self.workspace.name
    element = "<generated time=#{now.to_s.encode(xml: :attr)} user=#{user.to_s.encode(xml: :attr)} project=#{workspace.to_s.encode(xml: :attr)} />\n"
    xml_file.write(element)
    xml_file.flush
  end

  #
  # XML generation
  #

  # Outer sections

  # Populates <hosts> element for single workspace
  # @param xml_file [File] open XML file
  # @return [Boolean] whether fragment generation and cleanup was successful
  def add_hosts(xml_file)
    hosts_fragment = Nokogiri::XML::Builder.new(:encoding => 'utf-8') do |xml|
      xml.hosts do
        # Avoid superfluous queries by grabbing in batches
        Mdm::Host.where(find_conditions(:workspace)).
          includes(:exploit_attempts,
                   :host_details,
                   :notes,
                   :services,
                   :sessions,
                   :tags,
                   :vulns
          ).find_each(:batch_size => Export::COLLECTION_BATCH_SIZE,) do |host|
          # Verify the host is allowed
          next unless host_allowed?(host)

          xml.host do
            # Host attributes
            host.attributes.each do |attr, val|
              xml.send(dash(attr), val)
            end

            # Sub sections with records related to this host,
            # grabbing all attributes of each record in most cases
            # -- Exploit Attempts
            add_exploit_attempts(xml, host)
            # -- Host Details
            add_host_details(xml, host)
            # -- Notes
            add_notes(xml, host)
            # -- Services
            add_services_inner(xml, host)
            # -- Sessions
            add_sessions_inner(xml, host)
            # -- Tags
            add_tags(xml, host)
            # -- Vulnerabilities
            add_vulns(xml, host)
          end
        end

      end
    end
    section_generation_cleanup(xml_file, hosts_fragment)
  end

  # Populates <events> element for single workspace
  # @param xml_file [File] open XML file
  # @return [Boolean] whether fragment generation and cleanup was successful
  def add_events(xml_file)
    events_fragment = Nokogiri::XML::Builder.new(:encoding => Export::ENCODING) do |xml|
      xml.events do
        Mdm::Event.where(find_conditions(:workspace)).find_each(:batch_size => Export::COLLECTION_BATCH_SIZE,) do |event|
          # Verify the event is related to an allowed host
          # if it has one, otherwise we can only verify workspace (condition in find)
          if event.host
            next unless host_allowed?(event.host)
          end

          xml.event do
            # Event attributes
            event.attributes.each do |attr, val|
              if attr =~ /info/
                val = marshal_hash(val)
              end
              xml.send(dash(attr), val)
            end
          end
        end # each event
      end
    end
    section_generation_cleanup(xml_file, events_fragment)
  end

  # Wraps <sessions> generation in new Builder fragment and
  # calls cleanup for use in an outer element context.
  # @param xml_file [File] open XML file
  # @param parent [Mdm::Workspace] the parent Workspace the sessions are scoped to
  # @return [Boolean] whether fragment generation and cleanup was successful
  def add_sessions(xml_file, parent)
    session_fragment = Nokogiri::XML::Builder.new(:encoding => Export::ENCODING) do |xml|
      add_sessions_inner(xml, parent)
    end
    section_generation_cleanup(xml_file, session_fragment)
  end

  # Wraps <services> generation in new Builder fragment and
  # calls cleanup for use in an outer element context.
  # @param xml_file [File] open XML file
  # @param parent [Mdm::Workspace] the parent Workspace the services are scoped to
  # @return [Boolean] whether fragment generation and cleanup was successful
  def add_services(xml_file, parent)
    service_fragment = Nokogiri::XML::Builder.new(:encoding => Export::ENCODING) do |xml|
      add_services_inner(xml, parent)
    end
    section_generation_cleanup(xml_file, service_fragment)
  end

  # Wraps <credentials> generation in new Builder fragment and
  # calls cleanup for use in an outer element context.
  # @param xml_file [File] open XML file
  # @param parent [Mdm::Workspace] the parent Workspace the credentials are scoped to
  # @return [Boolean] whether fragment generation and cleanup was successful
  def add_credentials(xml_file, parent)
    credential_fragment = Nokogiri::XML::Builder.new(:encoding => Export::ENCODING) do |xml|
      add_credentials_inner(xml, parent)
    end
    section_generation_cleanup(xml_file, credential_fragment)
  end

  # Populates <web_sites> element for single workspace
  # @param xml_file [File] open XML file
  # @return [Boolean] whether fragment generation and cleanup was successful
  def add_web_sites(xml_file)
    web_sites_fragment = Nokogiri::XML::Builder.new(:encoding => Export::ENCODING) do |xml|
      xml.web_sites do
        self.workspace.web_sites.each do |web_site|
          next unless host_allowed?(web_site.service.host)
          # Re-use this host check to build up allowed sites
          # for use in additional web sections
          @web_sites << web_site
          xml.web_site do
            # Web site attributes
            web_site.attributes.each do |attr, val|
              if attr == 'options'
                xml.send(dash(attr), marshal_hash(val))
              else
                xml.send(dash(attr), val)
              end
            end
            # Related host
            xml.host web_site.service.host.address
            # Related port
            xml.port web_site.service.port
            # SSL enabled?
            ssl_enabled = (web_site.service.name == 'https')
            xml.ssl ssl_enabled
          end
        end # each web_site
      end # web_sites
    end
    section_generation_cleanup(xml_file, web_sites_fragment)
  end

  # Populates shared elements for web pages and forms
  # @param xml [Nokogiri::XML::Builder] the Builder object being appended to
  # @param web_site [Mdm::WebSite] the parent web site
  # @return [Nokogiri::XML::Builder] the resultant XML
  def add_web_subinfo(xml, web_site)
    # Related vhost
    xml.vhost web_site.vhost
    # Related host
    xml.host web_site.service.host.address
    # Related port
    xml.port web_site.service.port
    # SSL enabled?
    ssl_enabled = (web_site.service.name == 'https')
    xml.ssl ssl_enabled
  end

  # Populates <web_pages> for records in allowed sites.
  # @param xml_file [File] open XML file
  # @return [Boolean] whether fragment generation and cleanup was successful
  def add_web_pages(xml_file)
    web_pages_fragment = Nokogiri::XML::Builder.new(:encoding => Export::ENCODING) do |xml|
      xml.web_pages do
        @web_sites.each do |web_site|
          web_site.web_pages.each do |web_page|
            xml.web_page do
              # Web page attributes
              web_page.attributes.each do |attr, val|
                if attr == 'headers'
                  xml.send(dash(attr), marshal_hash(val))
                elsif attr == 'body' && !val.blank?
                  xml.send(dash(attr), Base64.urlsafe_encode64(val))
                else
                  nval = val.to_s.gsub(/\0/,'')
                  xml.send(dash(attr), nval)
                end
              end
              add_web_subinfo(xml, web_site)
            end
          end # each web_page
        end # each web site
      end # web_pages
    end # web_pages fragment
    section_generation_cleanup(xml_file, web_pages_fragment)
  end

  # Populates <web_forms> for records in allowed sites.
  # @param xml_file [File] open XML file
  # @return [Boolean] whether fragment generation and cleanup was successful
  def add_web_forms(xml_file)
    web_forms_fragment = Nokogiri::XML::Builder.new(:encoding => Export::ENCODING) do |xml|
      xml.web_forms do
        @web_sites.each do |web_site|
          web_site.web_forms.each do |web_form|
            xml.web_form do
              # Web form attributes
              web_form.attributes.each do |attr, val|
                case attr
                  when 'method'
                    xml.method_ val # This element name is reserved
                  when 'params'
                    xml.send(dash(attr), marshal_hash(val))
                  else
                    xml.send(dash(attr), val)
                end
              end
              add_web_subinfo(xml, web_site)
            end
          end # each web_form
        end # each web site
      end # web_forms
    end # web_forms fragment
    section_generation_cleanup(xml_file, web_forms_fragment)
  end

  # Populates <web_vulns> for records in allowed sites.
  # @param xml_file [File] open XML file
  # @return [Boolean] whether fragment generation and cleanup was successful
  def add_web_vulns(xml_file)
    web_vulns_fragment = Nokogiri::XML::Builder.new(:encoding => Export::ENCODING) do |xml|
      xml.web_vulns do
        @web_sites.each do |web_site|
          web_site.web_vulns.each do |web_vuln|
            xml.web_vuln do
              service = web_site.service
              ssl = case service.name
                      when 'https'
                        true
                      else
                        false
                    end
              category = web_vuln.category
              legacy_category = web_vuln.legacy_category
              proofs = web_vuln.proofs

              xml.host service.host.address
              xml.port service.port
              xml.method_ web_vuln.method
              xml.send('name', web_vuln.name)
              xml.ssl ssl
              xml.vhost web_site.vhost
              add_web_vuln_params(xml, web_vuln)
              # add owasp?
              if category
                xml.category do
                  xml.send('name', category.name)
                end
              end
              if legacy_category
                xml.send('legacy-category', legacy_category)
              end
              if proofs.size > 0
                add_web_vuln_proofs(xml, proofs)
              end
              # Legacy list of attrs exported:
              attrs = %w(blame confidence created_at description name path pname query risk updated_at)
              attrs.each do |attr|
                xml.send(dash(attr), web_vuln.send(attr))
              end

            end # web_vuln element
          end # each web_vuln
        end # each web_site
      end # web_vulns element
    end # web_vulns fragment
    section_generation_cleanup(xml_file, web_vulns_fragment)
  end

  # Adds <params> for the passed web_vuln
  # @param xml [Nokogiri::XML::Builder] the Builder object being appended to
  # @param web_vuln [Mdm::WebVuln] the parent WebVuln the params are for
  # @return [Nokogiri::XML::Builder] the resultant XML section
  def add_web_vuln_params(xml, web_vuln)
    xml.params do
      web_vuln.params.each do |param|
        # Array of arrays
        xml.param do
          xml.name  param[0]
          xml.value param[1]
        end
      end
    end
  end

  # Adds <proofs>
  # Currently only text proofs are exported.
  # TODO Image proofs
  # @param xml [Nokogiri::XML::Builder] the Builder object being appended to
  # @param proofs [Array] the proof strings to be added to this subsection
  # @return [Nokogiri::XML::Builder] the resultant XML section
  def add_web_vuln_proofs(xml, proofs)
    xml.proofs do
      proofs.each do |proof|
        xml.proof do
          xml.text_ do
            xml.send('text', proof.text)
          end
        end
      end
    end
  end

  # Filesystem-dependent sections

  # Adds <loots>
  # @param xml_file [File] open XML file
  # @param parent_dir [String] into which the related files should be copied
  def add_loots(xml_file, parent_dir)
    # Directory to hold loot
    loot_dir = File.join(parent_dir, "loot_#{Time.now.utc.to_i}")
    if add_filesystem_dir(loot_dir)
      loots_fragment = Nokogiri::XML::Builder.new(:encoding => Export::ENCODING) do |xml|
        xml.loots do
          self.workspace.loots.each do |loot|
            # If the loot file exists,
            # add XML section for it and copy file:
            unless loot.path
              logger.error "Loot file #{loot.id} has no path set."
              next
            end
            if File.exist?(loot.path)
              add_fs_dep_child(xml, loot, loot_dir)
            else
              logger.error "Loot file not found for loot #{loot.id}: #{loot.path}"
              next
            end
          end # each loot
        end # <loots>
      end
      # Removes the created dir if empty (no valid loot)
      drop_empty_dir(loot_dir)
      section_generation_cleanup(xml_file, loots_fragment)
    else
      return false
    end
  end

  # Adds <tasks>
  # @param xml_file [File] open XML file
  # @param parent_dir [String] into which the related files should be copied
  def add_tasks(xml_file, parent_dir)
    # Directory to hold tasks
    tasks_dir = File.join(parent_dir, "tasks_#{Time.now.utc.to_i}")
    if add_filesystem_dir(tasks_dir)
      tasks_fragment = Nokogiri::XML::Builder.new(:encoding => Export::ENCODING) do |xml|
        xml.tasks do
          self.workspace.tasks.each do |task|
            # If the task file exists,
            # add XML section for it and copy file:
            if ( task.path && File.exist?(task.path) )
              add_fs_dep_child(xml, task, tasks_dir)
            else
              logger.error "Task file not found for task #{task.id}: #{task.path}"
              next
            end
          end # each task
        end # <tasks>
      end
      # Removes the created dir if empty (no valid tasks)
      drop_empty_dir(tasks_dir)
      section_generation_cleanup(xml_file, tasks_fragment)
    else
      return false
    end
  end

  # Adds <reports>
  # @param xml_file [File] open XML file
  # @param parent_dir [String] into which the related files should be copied
  def add_reports(xml_file, parent_dir)
    # Directory to hold reports
    reports_dir = File.join(parent_dir, "reports_#{Time.now.utc.to_i}")
    if add_filesystem_dir(reports_dir)
      reports_fragment = Nokogiri::XML::Builder.new(:encoding => Export::ENCODING) do |xml|
        xml.reports do
          # TODO Fix:
          #self.workspace.reports.each do |report|
          ::Report.where("workspace_id = #{self.workspace.id}").each do |report|
            add_report(xml, report, reports_dir)
          end # each report
        end # <reports>
      end
      # Removes the created dir if empty (no valid reports)
      drop_empty_dir(reports_dir)
      section_generation_cleanup(xml_file, reports_fragment)
    else
      return false
    end
  end


  # Sub-sections

  # Populates <credentials> for a single workspace. Cores are the
  # starting point for data filtering, i.e. workspace association and host
  # inclusion. Host checks are done once on cores and then used in selecting
  # related objects, which are added in separate methods.
  #
  # @param xml [Nokogiri::XML::Builder] the Builder object being appended to
  # @param parent [Mdm::Workspace] the parent Workspace the credentials
  #   are related to
  # @return [Nokogiri::XML::Builder] the resultant XML section
  def add_credentials_inner(xml, parent)
    xml.credentials do
      # To ensure address white and blacklisting is respected we need
      # to verify the hosts that are associated with a core.
      permitted_cores = Set.new

      xml.cores do
        parent.core_credentials.each do |core|
          if core_allowed?(core)
            permitted_cores.add core
          else
            next
          end

          xml.core do
            core.attributes.each do |attr, val|
              xml.send(dash(attr), val)
            end
          end
        end
      end

      add_credential_origins(xml, permitted_cores)
      add_credential_realms(xml, permitted_cores)
      add_credential_publics(xml, permitted_cores)
      add_credential_logins(xml, permitted_cores)
      add_credential_privates(xml, permitted_cores)

    end # <credentials>
  end

  # Populates <origins> for the passed, allowed cores.
  # @param xml [Nokogiri::XML::Builder] the Builder object being appended to
  # @param cores [Set<Metasploit::Credential::Core>] unique
  #   allowed cores for which to extract origin.
  # @return [Nokogiri::XML::Builder] the resultant XML section
  def add_credential_origins(xml, cores)
    origins = cores.collect {|c| c.origin}
    # Avoid duplication since we are starting with cores
    origins = Set.new(origins)

    xml.origins do
      origins.each do |origin|
        xml.origin do
          origin.attributes.each do |attr, val|
            next if attr == 'workspace-id' # Superfluous
            xml.send(dash(attr), val)
          end
        end
      end
    end
  end

  # Populates <realms> for the passed cores.
  # @param xml [Nokogiri::XML::Builder] the Builder object being appended to
  # @param cores [Set<Metasploit::Credential::Core>] unique
  #   allowed cores for which to extract realms.
  # @return [Nokogiri::XML::Builder] the resultant XML section
  def add_credential_realms(xml, cores)
    realms = cores.collect {|c| c.realm}
    # Realm not required on core:
    realms = Set.new(realms).delete(nil)

    xml.realms do
      realms.each do |realm|
        xml.realm do
          realm.attributes.each do |attr, val|
            xml.send(dash(attr), val)
          end
        end
      end
    end
  end

  # Populates <publics> for the passed cores.
  # @param xml [Nokogiri::XML::Builder] the Builder object being appended to
  # @param cores [Set<Metasploit::Credential::Core>] unique
  #   allowed cores for which to extract publics.
  # @return [Nokogiri::XML::Builder] the resultant XML section
  def add_credential_publics(xml, cores)
    publics = cores.collect {|c| c.public}
    # Public not required on core:
    publics = Set.new(publics).delete(nil)

    xml.publics do
      publics.each do |public|
        xml.public do
          public.attributes.each do |attr, val|
            xml.send(dash(attr), val)
          end
        end
      end
    end
  end

  # Populates <logins> for the passed cores.
  # @param xml [Nokogiri::XML::Builder] the Builder object being appended to
  # @param cores [Set<Metasploit::Credential::Core>] unique
  #   allowed cores for which to extract logins.
  # @return [Nokogiri::XML::Builder] the resultant XML section
  def add_credential_logins(xml, cores)
    logins = Set.new
    core_logins = cores.collect do |c|
      c.logins.map {|l| logins.add l}
    end
    # Login not required on core
    logins.delete(nil)

    xml.logins do
      logins.each do |login|
        xml.login do
          login.attributes.each do |attr, val|
            xml.send(dash(attr), val)
          end
        end
      end
    end
  end

  # Populates <privates> for the passed cores.
  # @param xml [Nokogiri::XML::Builder] the Builder object being appended to
  # @param cores [Set<Metasploit::Credential::Core>] unique
  #   allowed cores for which to extract privates.
  # @return [Nokogiri::XML::Builder] the resultant XML section
  def add_credential_privates(xml, cores)
    privates = cores.collect {|c| c.private}
    # Private not required on core
    privates = Set.new(privates).delete(nil)

    xml.privates do
      privates.each do |private|
        xml.private do
          private.attributes.each do |attr, val|
            # Mask the credential value if desired
            if attr == 'data'
              val = mask_cred(val, self.mask_credentials)
              xml.data do
                xml.cdata val
              end
            else
              xml.send(dash(attr), val)
            end
          end
        end
      end
    end
  end

  # Populates <exploit_attempts> for a single host
  # @param xml [Nokogiri::XML::Builder] the Builder object being appended to
  # @param parent [Mdm::Host] the parent Host the exploit_attempts are for
  # @return [Nokogiri::XML::Builder] the resultant XML section
  def add_exploit_attempts(xml, parent)
    xml.exploit_attempts do
      parent.exploit_attempts.each do |attempt|
        xml.exploit_attempt do
          attempt.attributes.each do |attr, val|
            xml.send(dash(attr), val)
          end
        end
      end # each exploit attempt
    end
  end

  # Populates <host_details> for a single host
  # @param xml [Nokogiri::XML::Builder] the Builder object being appended to
  # @param parent [Mdm::Host] the parent Host the host_details are for
  # @return [Nokogiri::XML::Builder] the resultant XML section
  def add_host_details(xml, parent)
    xml.host_details do
      parent.host_details.each do |detail|
        xml.host_detail do
          detail.attributes.each do |attr, val|
            xml.send(dash(attr), val)
          end
        end
      end # each host detail
    end
  end

  # Populates <notes> for a single host
  # @param xml [Nokogiri::XML::Builder] the Builder object being appended to
  # @param parent [Mdm::Host] the parent Host the notes are for
  # @return [Nokogiri::XML::Builder] the resultant XML section
  def add_notes(xml, parent)
    xml.notes do
      parent.notes.each do |note|
        xml.note do
          note.attributes.each do |attr, val|
            if attr == 'data'
              xml.send(dash(attr), marshal_hash(val))
            else
              xml.send(dash(attr), val)
            end
          end
        end
      end # each note
    end
  end

  # Populates <services> for a single host or workspace
  # @param xml [Nokogiri::XML::Builder] the Builder object being appended to
  # @param parent [Mdm::Host,Mdm::Workspace] the parent object the services are scoped to
  # @return [Nokogiri::XML::Builder] the resultant XML section
  def add_services_inner(xml, parent)
    for_workspace = parent.is_a?(Mdm::Workspace)
    xml.services do
      parent.services.each do |service|
        # If iterating on services in a workspace, verify
        # the service is related to an allowed host:
        if for_workspace
          next unless host_allowed?(service.host)
        end
        # Base service attributes
        xml.service do
          service.attributes.each do |attr, val|
            xml.send(dash(attr), val)
          end
        end
      end # each service
    end
  end

  # Populates <sessions> for a parent host or workspace
  # @param xml [Nokogiri::XML::Builder] the Builder object being appended to
  # @param parent [Mdm::Host,Mdm::Workspace] the parent object the sessions are scoped to
  # @return [Nokogiri::XML::Builder] the resultant XML section
  def add_sessions_inner(xml, parent)
    for_workspace = parent.is_a?(Mdm::Workspace)
    xml.sessions do
      parent.sessions.each do |session|
        # If iterating on sessions in a workspace, verify
        # the session is related to an allowed host:
        if for_workspace
          next unless host_allowed?(session.host)
        end

        xml.session do
          # Base attrs
          session.attributes.each do |attr, val|
            if attr == 'datastore'
              xml.send(dash(attr), marshal_hash(val))
            else
              xml.send(dash(attr), val)
            end
          end

          # Related session events
          xml.events do
            session.events.each do |session_event|
              xml.event do
                session_event.attributes.each do |attr, val|
                  if (attr =~ /output|command/) && val.kind_of?(String)
                    # Legacy approach to make these attributes portable
                    # TODO Convert to more sane approach
                    val = [Marshal.dump(String.new(val))].pack("m").gsub(/\s+/,"")
                  end
                  xml.send(dash(attr), val)
                end
              end
            end
          end # related events

        end # session element
      end # each session
    end # sessions
  end

  # Populates <tags> for a single host
  # @param xml [Nokogiri::XML::Builder] the Builder object being appended to
  # @param parent [Mdm::Host] the parent Host the tags are for
  # @return [Nokogiri::XML::Builder] the resultant XML section
  def add_tags(xml, parent)
    xml.tags do
      parent.tags.each do |tag|
        xml.tag do
          # Base attrs
          tag.attributes.each do |attr, val|
            # Wrap description field in CDATA
            if attr == 'desc'
              xml.desc do
                xml.cdata val
              end
              # Legacy: False checkbox fields are simply self-closed
              # instead of recording false.
            elsif attr =~ /report_detail|report_summary|critical/
              if not val
                xml.send(dash(attr), nil)
              end
            else
              xml.send(dash(attr), val)
            end
          end
        end
      end # each tag
    end # tags
  end

  # Populates <vulns> for a single host
  # @param xml [Nokogiri::XML::Builder] the Builder object being appended to
  # @param parent [Mdm::Host] the parent Host the vulns are for
  # @return [Nokogiri::XML::Builder] the resultant XML section
  def add_vulns(xml, parent)
    xml.vulns do
      parent.vulns.each do |vuln|
        xml.vuln do
          # Base attrs
          vuln.attributes.each do |attr, val|
            xml.send(dash(attr), val)
          end
          xml.notes do
            vuln.notes.each do |vuln_note|
              xml.note do
                vuln_note.attributes.each do |attr, val|
                  if attr == 'data'
                    xml.send(dash(attr), marshal_hash(val))
                  else
                    xml.send(dash(attr), val)
                  end
                end
              end
            end
          end
          # Related refs
          xml.refs do
            vuln.refs.each do |vuln_ref|
              xml.ref vuln_ref.name
            end
          end
          # Related details
          xml.vuln_details do
            vuln.vuln_details.each do |vuln_detail|
              xml.vuln_detail do
                vuln_detail.attributes.each do |attr, val|
                  xml.send(dash(attr), val)
                end
              end
            end
          end
          # Related attempts
          xml.vuln_attempts do
            vuln.vuln_attempts.each do |vuln_attempt|
              xml.vuln_attempt do
                vuln_attempt.attributes.each do |attr, val|
                  xml.send(dash(attr), val)
                end
              end
            end
          end
        end
      end # each vuln
    end # vulns
  end

  # Populates a single filesystem dependent element, copying file to provided path
  # @param xml [Nokogiri::XML::Builder] the Builder object being appended to
  # @param obj [Mdm::Loot, Mdm::Task, Report] for which the element is generated
  # @param copy_path [String] dir where the file will be copied
  def add_fs_dep_child(xml, obj, copy_path)
    obj_type = obj.class.name.split('::').last.downcase
    xml.send(obj_type) do
      obj.attributes.each do |attr, val|
        if attr == 'path'
          copy_path = File.join(copy_path, File.basename(val))
          # Copy file to staging area:
          FileUtils.cp_r(val, copy_path)
          # Use path of copied file relative to XML file for export:
          rel_path = File.join('.', copy_path.split(File::SEPARATOR)[-2..-1])
          val = rel_path
        end
        # Legacy
        if attr == 'data' && !val.blank?
          xml.send(dash(attr), Base64.urlsafe_encode64(val))
        elsif attr =~ /options|settings/
          xml.send(dash(attr), marshal_hash(val))
        else
          xml.send(dash(attr), val)
        end
      end
    end
  end

  # Populates <report>, including report artifacts, copying files to provided path
  # @param xml [Nokogiri::XML::Builder] the Builder object being appended to
  # @param report [Report] for which the element is generated
  # @param copy_path [String] dir where the files will be copied
  def add_report(xml, report, copy_path)
    artifacts = report.report_artifacts
    unless artifacts.count > 0
      logger.error "No artifacts found for report #{report.id}"
      return false
    end
    xml.report do
      # Base report attributes
      report.attributes.each do |attr, val|
        xml.send(dash(attr), val)
      end
      # Child artifacts
      xml.artifacts do
        artifacts.each do |a|
          xml.artifact do
            a.attributes.each do |attr, val|
              # Copy artifact file
              if attr == 'file_path'
                FileUtils.copy(val,copy_path)
                # Path is relative to XML file
                rel_path = File.join('.', File.basename(copy_path), File.basename(val))
                val = rel_path
              end
              xml.send(dash(attr), val)
            end
          end
        end # each artifact
      end # <artifacts>
    end
  end

end
