module Metasploit::Pro::Report::Utils

  include Metasploit::Pro::AddressUtils

  #
  # Constants
  #
  REPORT_FILE_EXTENSIONS = {:pdf   => 'pdf',
                            :html  => 'html',
                            :xhtml => 'html',
                            :word  => 'docx',
                            :rtf   => 'rtf',
                            :xml   => 'xml'}

  LINUX_XVFB_DEPENDENCY = "Please ensure that Xvfb is installed on your system as well as the required
                           libraries (libfontconfig and libXrender), without them images for the landing
                           and redirect pages, as well as all graphs will be missing."

  REQUIRED_DATA = "Report not ready for artifact generation, required data missing."

  def report_logger
    unless instance_variable_defined? :@report_logger
      log_pathname = File.join(Report::LOG_FILE)
      @report_logger = Logger.new(log_pathname)
      @report_logger.level = Logger::INFO
      @report_logger.formatter = proc do |severity, datetime, program_name, msg|
        "#{severity}: #{datetime}: (#{self.id}) #{msg}\n"
      end
    end
    @report_logger
  end

  # summary of required data
  def required_data_message(report_type)
    missing_data_message = [ REQUIRED_DATA ]
    if report_type.respond_to?(:required_data)
      missing_data_message << "The following data must exist in the project for this report:"
      types = report_type.required_data.map { |data_type| data_type.to_s.humanize.capitalize }
      missing_data_message << types.join(', ')
    end
    missing_data_message.join(" ")
  end

  #
  # Misc
  #

  # Expands any ranges in the passed included_ and excluded_addresses
  # and calculates which hosts in the resultant list
  # should be allowed according to various conditions.
  # Reports and exports share the same notion of allowed_addresses
  # except for exports require that hosts are alive.
  #
  # @param included_addresses [String] host addresses to include from
  # user input, so can include wildcards, ranges, etc.
  # @param excluded_addresses [String] host addresses to exclude, like included
  # @param alive [Boolean] whether hosts must be alive
  # @param workspace_id [Integer] of the related export/report run
  # @return [Array<String>] of each allowed host's address
  def generate_allowed_addresses(included_addresses, excluded_addresses, alive, workspace_id)
    allowed_addresses = []
    workspace   = Mdm::Workspace.find(workspace_id)
    expand_opts = {workspace: workspace} # For tag expansion
    nothing_specified = (included_addresses.blank? && excluded_addresses.blank?)
    both_specified    = (!included_addresses.blank? && !excluded_addresses.blank?)

    if nothing_specified
      allowed_addresses = workspace.hosts.collect {|h| h.address }
    elsif both_specified
      expanded_included = Metasploit::Pro::AddressUtils.expand_ip_ranges(included_addresses, expand_opts)
      expanded_excluded = Metasploit::Pro::AddressUtils.expand_ip_ranges(excluded_addresses, expand_opts)
      expanded_included - expanded_excluded
    # Just included:
    elsif !included_addresses.blank?
      Metasploit::Pro::AddressUtils.expand_ip_ranges(included_addresses, expand_opts)
    # Just excluded:
    elsif !excluded_addresses.blank?
      all_hosts = alive ? workspace.hosts.where(:state => 'alive') :
                    workspace.hosts
      all_hosts = all_hosts.collect {|h| h.address }
      expanded_excluded = Metasploit::Pro::AddressUtils.expand_ip_ranges(excluded_addresses, expand_opts)
      all_hosts - expanded_excluded
    end
  end

  # @param report_type [String]
  # @return [String] path to parent Jasper jrxml template file
  def template_file(report_type)
    Report::REPORT_TYPE_MAP[report_type].template_file
  end


  #
  # Utilities
  #

  # @return [String] indicating current OS
  def current_platform
    case RUBY_PLATFORM
      when /darwin/i
        'darwin' # OS X
      when /^win|mingw/i
        'windows'
      when /linux/i
        case RUBY_PLATFORM
          when /64/
            'linux64'
          # Handle cases like i686 as well:
          when /32|86/
            'linux32'
        end
      # TODO Handle jRuby, will likely appear as Java
      else
        'unknown'
    end
  end

  # Crafts SQL clause to limit report queries to desired addresses.
  # @param included_addresses [String] un-expanded user specification
  # of addresses to be included.
  # @param excluded_addresses [String] un-expanded user specification
  # of addresses to be excluded.
  def host_address_clause(included_addresses, excluded_addresses)
    nothing_specified = (included_addresses.empty? && excluded_addresses.empty?)
    both_specified = (!included_addresses.empty? && !excluded_addresses.empty?)

    if nothing_specified
      # No change to query, just add clause that won't error:
      'hosts.address is not null'
    elsif both_specified
      expanded_included = Metasploit::Pro::AddressUtils.expand_ip_ranges(included_addresses)
      expanded_excluded = Metasploit::Pro::AddressUtils.expand_ip_ranges(excluded_addresses)
      allowed = expanded_included - expanded_excluded
      allowed_str = array_to_quoted_string(allowed)
      "hosts.address IN (#{allowed_str})"
    # Just included:
    elsif !included_addresses.empty?
      expanded_included = Metasploit::Pro::AddressUtils.expand_ip_ranges(included_addresses)
      included_str = array_to_quoted_string(expanded_included)
      "hosts.address IN (#{included_str})"
    # Just excluded:
    elsif !excluded_addresses.empty?
      expanded_excluded = Metasploit::Pro::AddressUtils.expand_ip_ranges(excluded_addresses)
      excluded_str = array_to_quoted_string(expanded_excluded)
      "hosts.address NOT IN (#{excluded_str})"
    end
  end

  # Converts credential to mask if report option is set
  # If not masking, returns indication of empty if value is blank.
  # @return [String]
  def mask_cred(credential, to_mask = false)
    if to_mask
      return Export::MASKED_CRED  # Used to be <masked>, which just looks like an invalid element
    else
      if credential.empty? || credential.nil?
        Export::EMPTY_CRED
      else
        credential
      end
    end
  end

  # @param file_path [String] of report artifact
  # @param parent_report_name [String]
  # @return [String] of unique artifact path
  def unique_report_filename(file_path, parent_report_name)
    if File.exist? file_path
      # If there's an existing file, add the current timestamp for more originality:
      artifact_name = "#{parent_report_name}-#{now_to_ms}#{File.extname(file_path)}"
      file_path = File.join(Report::ARTIFACT_DIR, artifact_name)
    end
    file_path
  end

  # Checks if passed dir exists, creates if it doesn't
  # @param dir [String] full path of directory to verify
  def verify_dir_created(dir)
    FileUtils.mkdir_p dir
  end

  # @return [Integer] of milliseconds elapsed since Unix Epoch
  def now_to_ms
    (Time.now.to_f*1000).to_i
  end

  # Creates comma-separated string of each array member wrapped in quotes
  # @param arr [Array] of strings
  # @return [String]
  def array_to_quoted_string(arr)
    arr.collect { |a| "'#{a}'" }.join(', ')
  end

  # Provides a hash safe for making into yaml
  # for Jasper consumption:
  #  * HWIA to Hash
  #  * keys to strings
  #  * ensures all keys and values are UTF-8 strings
  #    where possible
  #
  # @param hash [Hash] the Hash or HWIA to sanitize
  # @return [Hash] the sanitized hash
  def sanitize_hash(hash)
    hash = hash.to_hash # In case of HWIA
    # Java will choke on symbols, make sure keys are symbols:
    hash.stringify_keys!

    hash.each_with_object({}) { |(k,v), h|
      # Make sure all keys are UTF-8;
      # make sure all values that are stringlike are UTF-8
      h[k.encode('UTF-8')] = (v.respond_to? :encode) ?
                              v.encode('UTF-8') : v
    }
  end

  # Parameterize filename, preserves case
  # @param string [String] to be sanitized
  # @param sep [String] safe char to replace bad items with
  # @return [String] sanitized
  def sanitize_filename(string, sep = '-')
    # replace accented chars with their ascii equivalents, force to UTF-8 due to Rails 6 `transliterate` restrictions
    parameterized_string = ActiveSupport::Inflector.transliterate(string.force_encoding("UTF-8"))
    # Turn unwanted chars into the separator
    parameterized_string.gsub!(/[^a-z0-9\-_.]+/i, sep)
    unless sep.nil? || sep.empty?
      re_sep = Regexp.escape(sep)
      # No more than one of the separator in a row.
      parameterized_string.gsub!(/#{re_sep}{2,}/, sep)
      # Remove leading/trailing separator.
      parameterized_string.gsub!(/^#{re_sep}|#{re_sep}$/, '')
    end
    parameterized_string
  end

  # Replaces sources in image tags with the Base64 encoding of the
  # referenced images.
  # This allows the HTML file to be self-contained.
  # See RFC 2397 ( http://tools.ietf.org/html/rfc2397 )
  #
  # @param html_file_path [String] the path of the file to be transformed
  # @return [Boolean] whether the embedding operation succeeded
  def html_embed_images(html_file_path)
    init_html_file = File.open(html_file_path)
    html = Nokogiri::HTML(init_html_file) # TODO Parsing errors
    init_html_file.close

    # Iterate through all img elements,
    # Base64 encode their source file content
    html.css('img').each do |img|
      src = img['src']
      # HTML image file paths are relative to the HTML doc
      path_from_html = File.expand_path(src, File.dirname(html_file_path))
      next unless File.exist? path_from_html # Log?

      img_data = File.read(path_from_html, mode: 'rb')
      # Detect filetype with first few bytes:
      magic_string = img_data[0..3]
      img_mimetype = case magic_string
                       when 'GIF8' then 'image/gif'
                       when "\xFF\xD8\xFF\xE0" then 'image/jpeg'
                       when "\x89PNG" then 'image/png'
                       else
                         type_from_extension = MIME::Types.type_for(File.extname(path_from_html)).first
                         if type_from_extension&.media_type != 'image'
                           report_logger.error "Unknown image magic: #{magic_string.inspect} for #{path_from_html}"
                           nil
                         else
                           type_from_extension.simplified
                         end
                     end
      encoded_img = Base64.strict_encode64(img_data)
      encoded_src = "data:#{img_mimetype};base64,#{encoded_img}"
      img['src'] = encoded_src
      width = img['width']
      height = img['height']
      img['style'] = "width:#{width};" if width
      img['style'] += "height:#{height};" if height
    end

    # rewrite original file with updated HTML
    File.open(html_file_path, 'w') {|f| f.write(html.to_s) }
  end

  # Standardizes how each section creates and writes the XML fragment.
  # @param xml_file [File] open XML file
  # @param xml_fragment [Nokogiri::XML::Document] to be added
  # @return [Boolean] whether cleanup was successful
  def section_generation_cleanup(xml_file, xml_fragment)
    # .doc.root removes the XML declaration
    doc_root = xml_fragment.doc.root
    xml_file.write(doc_root.to_xml)
    # Break after each subsection
    xml_file.write("\n")
    # Flush to disk
    xml_file.flush
  end

  # Reads contents of task log files, handles various potential issues.
  # @param file_path [String] path file task log file
  # @return [String] content of task log file or error message.
  def task_log_content(file_path)
    unless File.exist? file_path
      return "Unable to find task log file: #{file_path}"
    end

    readable = File.readable? file_path
    size = File.size file_path

    content = if readable
                if size.nil? || size == 0
                  'Task log file empty.'
                else
                  if size > 150000
                    # Log file is large-ish, let's not include the whole thing in the report.
                    # We'll strip out some of the middle portion. (MS-1673)
                    count = 100
                    raw = ""
                    raw << "\n\n ***************************************************************************** \n\n"
                    raw << "\n --- A portion of this task log has been omitted to conserve report length --- \n"
                    raw << "\n --- Full task log content can be found in #{file_path} --- \n"
                    raw << "\n\n ***************************************************************************** \n\n"
                    raw << File.readlines(file_path)[0..count].join
                    raw << ".\n.\n.\n   OMITTED CONTENT, can be found in #{file_path}\n.\n.\n.\n"
                    raw << File.readlines(file_path)[-count..-1].join
                  else
                    raw = File.read(file_path)
                  end
                  utf8_only = raw.encode('UTF-8', :invalid => :replace, :undef => :replace)
                  utf8_only.encode(:xml => :text)
                end
              else
                "Task log file not readable: #{file_path}"
              end
    return content
  end


  #
  # Emailing
  #

  # @param string [String] of one or more email addresses
  # @return [Array] of split addresses
  def emails_string_to_array(string)
    return [] unless string # this may be better served to have callers test early.
    splitted = string.split(/,|;|\s| /).reject!(&:empty?)
    if splitted.blank?
      [string]
    else
      splitted
    end
  end

  # Sends email to recipients with attached files
  #
  # @param report_id [Integer] the ID of the report with artifacts to email
  # @param recipients [String] email address(es), separated by commas
  # @param report_artifact_ids [Array<Integer>] the ids of the report artifacts
  #   to attach to the email
  #
  # @return [Boolean] whether send was successful or not
  # TODO: While this is mixed in elsewhere, passing in the report's id to a call off
  #   of a report object feels icky.
  def email_report(report_id, recipients, report_artifact_ids = nil)
    # TODO: This method REALLY ought to be tested.
    recipients = emails_string_to_array(recipients)
    report = Report.find(report_id)
    report_name = report.rtype.name
    report_artifacts = report_artifact_ids ? report.report_artifacts.where(id: report_artifact_ids) : self.report_artifacts
    files = report_artifacts.collect {|r| r.file_path}

    artifacts_format_list = report_artifacts.collect(&:file_format)
    format_list = artifacts_format_list.collect {|x| x.upcase}.join(', ')

    message = MailMessage.new
    message.subject      = "[metasploit] Generated #{report_name} Report"
    message.from_address = 'reports@pro.metasploit.com'
    message.body         = "Selected formats (#{format_list}) of #{report_name} report are attached."
    # Add recipients and attach artifacts
    # TODO Is this working with multiple recipients?
    recipients.each {|r| message.add_recipient(r) }
    files.each do |f|
      name = File.basename(f)
      data = File.binread(f)
      message.add_attachment(name, data)
    end
    logger.info "Artifacts of report will be sent to #{recipients.size} address(es) using global SMTP settings"
    begin
      Mdm::Profile.load_latest_smtp_configuration
      ActionMailerSender.new.send(message)
    rescue StandardError => e
      logger.error("Problem emailing report: #{e}")
      return false
    end
  end


  #
  # Java
  #

  # @return [String] of paths to required jars for report generation
  def java_classpath
    classpaths = []
    classpaths << 'bin'
    # Base Jasper library:
    classpaths << 'lib/jasperreports-6.18.1.jar'
    # Various deps:
    classpaths << 'lib/barbecue-1.5-beta1.jar'
    classpaths << 'lib/commons-beanutils-1.9.4.jar'
    classpaths << 'lib/commons-collections4-4.2.jar'
    classpaths << 'lib/commons-digester-2.1.jar'
    classpaths << 'lib/commons-lang3-3.4.jar'
    classpaths << 'lib/commons-logging-1.2.jar'
    classpaths << 'lib/groovy-4.0.3.jar'
    classpaths << 'lib/groovy-xml-4.0.3.jar'
    classpaths << 'lib/iTextAsian-2.1.7.jar'
    classpaths << 'lib/itext-2.1.7.jar'
    classpaths << 'lib/jcommon-1.0.24.jar'
    classpaths << 'lib/jfreechart-1.0.19.jar'
    classpaths << 'lib/postgresql-42.3.6.jar'
    classpaths << 'lib/snakeyaml-1.30.jar'
    classpaths << 'lib/xalan-2.7.2.jar'
    # Generic utilities:
    classpaths << 'lib/metasploit/metasploit-util.jar'
    # Various extensions to charts:
    classpaths << 'lib/metasploit/ChartCustomizers2.jar'
    # Chart theme deps:
    classpaths << 'lib/castor-core-1.4.1.jar'
    classpaths << 'lib/castor-xml-1.4.1.jar'
    classpaths << 'lib/javax.inject-1.jar'
    classpaths << 'lib/spring-beans-5.3.20.jar'
    classpaths << 'lib/spring-core-5.3.20.jar'
    classpaths << 'lib/spring-jcl-5.3.20.jar'
    # Note that log4j logging is turned off via option passed to JR call.
    # This is to avoid spring issue (tries to output to log, hangs if it can't).
    # Adding the conf to classpath did not have any effect.
    classpaths << 'lib/log4j-api-2.17.2.jar'
    classpaths << 'lib/log4j-core-2.17.2.jar'
    # Enables chart themes:
    classpaths << 'lib/jasperreports_extensions.properties'
    classpaths << 'lib/jasperreports-chart-themes-6.18.1.jar'
    # Our compiled custom chart themes:
    classpaths << 'lib/metasploit/se_charts.jar'
    classpaths << 'lib/metasploit/SparklineTheme.jar'
    # Embedded font:
    classpaths << 'lib/liberation-sans.jar'
    # Allow style templates to call each other
    classpaths << '../reports/style_templates'

    classpaths.map! {|x| File.join(pro_java_directory,x.split('/'))}

    # On Windows platforms Java uses semicolons between path items
    join_char = (current_platform =~ /^win.*/ ? ';' : ':')
    classpaths.join(join_char)
  end

  # @return [Array] of various arguments to the JVM
  def shared_java_args(classpath)
    args = []
    # Headless mode
    args << '-Djava.awt.headless=true'
    # Development/debugging only:
    #args << "-Dcom.sun.management.jmxremote=true"
    # Adding this config file to JR classpath did not cause it to take
    # effect. Specifying directly as passed options does:
    args << "-Dlog4j2.configurationFile=file:#{File.join(pro_java_directory, 'lib', 'log4j2.properties')}"
    #args << "-Dlog4j.debug"
    args << "-cp #{classpath}"
  end


  #
  # Social Engineering
  #

  # @return [Boolean] if Xvfb is installed locally
  def xvfb_installed?
    unless RUBY_PLATFORM =~ /linux/
      return false
    end
    cmd = 'which Xvfb'
    cmd_popen = ::Open3.popen3(cmd)
    exit_status = cmd_popen[3].value

    return exit_status.success?
  end

  # @return [String] path to wkhtmltoimage binary for current platform
  def wkhtmltoimage
    case current_platform
    when 'darwin'
      wk_binary = File.join(Report::WKHTMLTOIMAGE_DIR, 'wkhtmltoimage-osx')
      full_cmd = wk_binary # No other components needed
    when /^win.*/ # Windows
      wk_binary = File.join(Report::WKHTMLTOIMAGE_DIR, 'wkhtmltoimage.exe')
      full_cmd = wk_binary # No other components needed
    when /linux/ # Linux
      if current_platform == 'linux32'
        wk_binary = File.join(Report::WKHTMLTOIMAGE_DIR, 'wkhtmltoimage-linux32')
      else
        wk_binary = File.join(Report::WKHTMLTOIMAGE_DIR, 'wkhtmltoimage-linux64')
      end
      virt_x11 = 'xvfb-run --auto-servernum --server-args=\'-screen 0, 1024x680x24\''
      full_cmd = virt_x11 + ' ' + wk_binary + ' --use-xserver'
      unless xvfb_installed?
        logger.error 'Unable to generate images on this system. Please install the xvfb package.'
        return false
      end
    else
      logger.error "Unable to generate image, OS (#{current_platform}) unknown."
      return false
    end

    unless File.exist?(wk_binary)
      logger.error "Unable to generate image, wkhtmltoimage is not installed: #{wk_binary}"
      return false
    end

    full_cmd
  end

  def gen_webpage_image(page_name, img_name, html_content)
    options = '-f png --quality 85 --javascript-delay 500 --crop-h 768' # wkhtmltoX
    preview_dir = File.join(Report::REPORTING_DIR, 'social_engineering', 'se_webpage_previews')

    img_path = File.join(preview_dir, "#{img_name}.png")
    html_path = File.join(preview_dir, "#{img_name}.html")
    # HTML temporarily on FS for wkhtmltoX use
    File.open(html_path, 'w') {|f| f.write(html_content) }

    wkhtmltoimage_base = wkhtmltoimage
    cmd = "#{wkhtmltoimage_base} #{options} #{html_path} #{img_path}"
    if !wkhtmltoimage_base || cmd.blank?
      logger.debug "Unable to generate image for #{img_name}."
      return false
    end
    errors = []
    outs, errs, status = Open3.capture3(cmd)
    outs = outs.encode('UTF-8', :invalid => :replace, :undef => :replace)
    errs = errs.encode('UTF-8', :invalid => :replace, :undef => :replace)

    # Status code 1 not always returned on failure
    if !status.success? || errs =~ /No such process/
      errors << outs
      # xvfb-run should spit back missing .so errors to stdout
      if errors.any? { |err| err =~ /libXrender|libfontconfig/i }
        errors = ["You are missing required libraries to generate a preview image. Please make sure libXrender and libfontconfig are installed."]
      elsif errors.any? { |err| err =~ /libz/i }
        errors = ["You are missing a required library to generate a preview image. Please make sure libz (v1.2.9+) is installed."]
      end

      logger.error "Image generation failed: #{errors.join('; ')}"
      return false
    end
    File.delete(html_path) # Cleanup

    if File.exist? img_path
      if File.size?(img_path).nil?
        File.delete(img_path) # Leaving empty images will cause errors for Jasper
        logger.error "Removed empty image: #{img_path}"
      end
    else
      errors << "#{img_path} does not exist."
    end
    if errors.length > 0
      logger.error "Attempted to generate image using: #{cmd}"
      logger.error "Errors: #{errors.join('; ')}"
    end
    img_path
  end # gen_webpage_image


  #
  # PCI, FISMA

  #
  # Checks username against set of known generic ones.
  # @param username [String] to be checked
  # @return [Boolean] if username is generic
  def generic_user?(username)
    generic = %w{
        user root administrator admin
        tomcat cisco manager sa
        postgres guest
      }

    (generic.member? username.downcase)
  end

  # Converts private type to more human-friendly string.
  # @param type [String]
  # @return [String]
  def pretty_private_type(type)
    case type
      when /ssh/i
        'SSH Private Key'
      when /ntlm/i
        'NTLM Hash'
      when /Nonreplayable/i
        'Non-replayable Hash'
      when /password/i
        'Password'
    end
  end

  # This checks if an exploit is skippable for the purposes of PCI req 6.1.
  # The first three are run as part of bruteforce, which means they're post-auth,
  # and thus, don't indicate missing patches. Strictly speaking, 0days and other
  # unpatched vulns should go here, too (it would be nice if exploits had this
  # data attached to them, really).
  # @return [Array] of skippable exploits
  def compliance_skippable_exploits
    skippable = %w{
      exploit/windows/smb/psexec
      exploit/windows/mssql/mssql_payload
      exploit/multi/http/tomcat_mgr_deploy
    }
  end

end
