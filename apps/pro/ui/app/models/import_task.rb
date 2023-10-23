class ImportTask < TaskConfig

  # path to the file to import
  attr :path

  # nexpose site to import
  attr :site_name

  attr_accessor :blacklist, :preserve_hosts, :sites, :autotag_os, :tags
  attr_reader :delete_original_file, :no_files

  def initialize(attributes)

    super(attributes)

    @path                 = attributes[:path]
    @blacklist            = attributes[:blacklist] || []
    @blacklist            = tags_and_addresses(@blacklist)
    @tags                 = attributes[:tags].gsub(' ','_') unless attributes[:tags].nil?
    @autotag_os           = set_default_boolean(attributes[:autotag_os], false)
    @preserve_hosts       = set_default_boolean(attributes[:preserve_hosts], false)
    @pwdump               = false

    if attributes[:delete_original_file] == false
      @delete_original_file = false
    else
      @delete_original_file = true
    end

    if attributes[:blacklist_string]
      @blacklist = tags_and_addresses(attributes[:blacklist_string].split(/\s+/))
    end

    @no_files = set_default_boolean(attributes[:no_files], false)

    @file_path = attributes[:file_path]
    @validate_file_path = set_default_boolean(attributes[:validate_file_path], false)

    @site  = attributes[:site_name]
    @sites = [ ['', ''] ]
    Mdm::NexposeConsole.where(enabled: true, status: "Available").each do |console|
      ( console.cached_sites || [] ).each do |sname|
        @sites << [ "#{console.name} - #{sname}", "#{console.name}________#{sname}" ]
      end
    end

    @nexpose_console = nil
    @nexpose_site    = nil
    if @site and @site.length > 0
      @nexpose_console,@nexpose_site = @site.split("________", 2)
    end

  end


  def blacklist_string
    blacklist.join("\n")
  end

  def valid?
    if @validate_file_path
      if @file_path.empty?
        @error = "No File Provided"
        return false
      end

      unless @file_path.match(/\.zip|\.pcap|\.xml|\.txt/)
        @error =  "File type is invalid or unknown"
        return false
      end
    end

    if !@no_files and not (@nexpose_console and @nexpose_site)
      if @path.nil? or @path.empty?
        @error = "No file provided"
        return false
      end

      unless File.exist? @path
        @error = "File not found"
        return false
      end

      unless File.readable? @path
        @error = "Cannot read file"
        return false
      end

      unless validate_import_file(@path)
        @error ||= "File type is invalid or unknown."
        return false
      end
    end

    blacklist.each do |ip|
      next if valid_ip_or_range?(ip)
      @error = "Invalid excluded IP address: #{ip}"
      return false
    end

    # If you've gotten this far, you're valid.
    @error = nil
    return true
  end

  # Returns the error message from the previous call to valid?()
  def error
    @error
  end

  # Calls out to the framework to actually give us a pass/fail
  # on the file format, unless it's a binary file type (zip, pcap).
  def validate_import_file(fpath)
    # TODO: gut this method and do the checks in the following way:
    #  - zip: can it be opened by Zip::File.open? If so, does it contain an XML file?
    #  - pwdump: does it match a chunk of the header boiler plate declaring it to be pwdump?
    #  - pcap: retain existing check, since idk what that is about

    import_file = File.open(fpath, 'rb')

    if import_file.stat.size < 4
      @error = "File is too small or not a real file"
      return false
    end

    test_bytes = import_file.stat.size > 8192 ? 8192 : import_file.stat.size # 8k seems reasonable
    test_data  = import_file.read(test_bytes)

    # Is it a Zip?
    if test_data[0, Metasploit::Credential::Importer::Zip::ZIP_HEADER_BYTE_LENGTH] == Metasploit::Credential::Importer::Zip::ZIP_HEADER_IDENTIFIER
      begin
        Zip::File.open(fpath) do |zip_file|
          if zip_file.glob('*.xml').blank?
            @error = "Zip file contains no XML archive"
            return false
          else
            return true
          end
        end
      rescue ::Zip::Error
        @error = "Zip file is malformed and can't be processed"
        return false
      end
    end

    # Is it a pcap file?
    # TODO: capture these magic byte strings as constants somewhere
    if test_data[0,4] == "\xA1\xB2\xC3\xD4".force_encoding('ASCII-8BIT') or test_data[0,4] == "\xD4\xC3\xB2\xA1".force_encoding('ASCII-8BIT')
      return true
    end

    # Check if PWDump file and return true
    # XXX: This requires the first line to be a valid hash
    if test_data.index("\n")
      @pwdump = true if test_data[0, test_data.index("\n")] =~ /^([^\s:]+):[0-9]+:([A-Fa-f0-9]+:[A-Fa-f0-9]+):[^\s]*$/
      @pwdump = true if test_data[0, test_data.index("\n")] =~ /^([^\s:]+):([0-9]+):NO PASSWORD\*+:NO PASSWORD\*+[^\s]*$/
      if @pwdump and f.stat.size > 1024**2
        @error = "PWDump file too large (over 1MB)"
        return false
      end
      return true if @pwdump
    end

    # If we're this far, go ahead and validate it for real over RPC.
    c = Pro::Client.get
    c.validate_import_file(test_data)
  end

  # Used conditionally in rpc_call when @pwdump is true
  def import_creds_config_hash
    {
    'DS_IMPORT_PATH'     => path,
    'workspace'          => workspace.name,
    'username'           => username,
    'DS_FTYPE'           => "pwdump",
    'DS_NAME'            => "imported_pwdump",
    'DS_DESC'            => "Imported pwdump on #{Time.new.utc}",
    'DS_ORIG_FILE_NAME'  => "pwdump",
    'DS_REMOVE_FILE'     => delete_original_file
    }
  end
  
  # Used in rpc_call when @pwdump is false
  def config_to_hash
    conf = {
      'DS_PATH'   => path,
      'workspace' => workspace.name,
      'username'  => username,
      'DS_BLACKLIST_HOSTS'  => blacklist_string,
      'DS_PRESERVE_HOSTS'   => preserve_hosts,
      'DS_REMOVE_FILE'      => delete_original_file,
      'DS_ImportTags'       => true
    }

    conf['DS_PATH'] = path if path
    if @nexpose_console and @nexpose_site
      conf['DS_NEXPOSE_CONSOLE']  = @nexpose_console.to_s
      conf['DS_NEXPOSE_SITE']     = @nexpose_site.to_s
    end

    conf['DS_AUTOTAG_OS'] = autotag_os
    conf['DS_AUTOTAG_TAGS'] = tags
    conf
  end

  def rpc_call
    #if we are dealing with a pwdump import, hijack the import
    # and send to import creds with default desc and name.
    if @pwdump
      client.start_import_creds(import_creds_config_hash)
    else
      client.start_import(config_to_hash)
    end
  end

end

