# This class is responsible for connecting to Sonar and pulling down host and
# port information based off a FDNS search parameter. It will create all the
# `Mdm::Host` and `Mdm::Service` records.
class Metasploit::Pro::Engine::Sonar::Importer


  # @return [Sonar::Client] the Sonar Client used to talk to Sonar
  attr_accessor :client
  # @return [Sonar::Data::ImportRun] the import run to base our query off of
  attr_accessor :import_run
  # @return [Thread::Queue] the queue holding all hosts to be turned into {Mdm::Host}s
  attr_accessor :service_queue
  # @return [Array<String>] the tags to apply to each `Mdm::Host`
  attr_accessor :tags
  # @return [Integer] the `Mdm::Workspace#id`
  attr_accessor :workspace_id

  # Imposes a limit of 5 results per batch on the Sonar search.
  # This is to ensure that we are always returned a RequestIterator.
  SONAR_QUERY_LIMIT = 5

  # @param import_run [Sonar::Data::ImportRun] the import run to base our query off of
  # @param workspace_id [Integer] `Mdm::workspace#id` to create the `Mdm::Host`s in
  # @param tags [Array<String>]  The tag to apply to the `Mdm::Host`s
  def initialize(import_run:, tags: [])
    @import_run    = import_run
    @service_queue = Queue.new
    @workspace_id  = import_run.workspace_id
    if tags.blank?
      @tags = []
    else
      @tags = tags
    end
    @client = Sonar::Client.new(client_options)
  end


  # Checks a response from Sonar to see if it is
  # an error. If so it raises a `SonarError`
  #
  # @param response [Hashie::Mash,Sonar::Request::RequestIterator] the response from the Sonar endpoint
  # @raise [SonarError] if the response is a JSON error response
  def check_for_error(response)
    if response.respond_to? :has_key?
      if response.has_key?(:error)
        raise Metasploit::Pro::Engine::Sonar::Error, response[:error]
      end
    end
  end

  # Takes a {Sonar::Data::Fdns} and creates
  # an {Mdm::Host} for it.
  #
  # @param fdns [Sonar::Data::Fdns] the Fdns record for the host
  # @return [Mdm::Host] the actual `Mdm::Host` object
  def create_host(fdns)
    host_obj = Mdm::Host.where(address: fdns.address, workspace_id: workspace_id).first_or_create!
    host_obj.name = fdns.hostname
    host_obj.save!
    host_obj
  end

  # Take an `Mdm::Host` and creates an `Mdm::Tag`
  # using the #tag attribute.
  #
  # @param host [Mdm::Host] the host to create the tag for
  # @param tag [String] the tag to create and apply to the host
  # @return [Mdm::Tag]
  def create_host_tag(host, tag)
    tag_obj = Mdm::Tag.where(name: tag, desc: tag).first_or_create!
    Mdm::HostTag.where(host_id: host.id, tag_id: tag_obj.id).first_or_create!
    tag_obj
  end

  # Takes an `Mdm::Host` and creates an `Mdm::Note` containing
  # the last seen date.
  #
  # @param host [Mdm::Host] the `Mdm::Host` for which to make the `Mdm::Note`
  # @param date [Date] the date of the last time Sonar saw this host
  # @return [Mdm::Note] the `Mdm::Note` we created
  def create_last_seen_note(host, date)
    note_obj = Mdm::Note.where(workspace_id: workspace_id, host_id: host.id, ntype: 'sonar.last_seen').first_or_create!
    note_obj.data = date.to_s
    note_obj.save!
    note_obj
  end

  # Takes an `Mdm::Host` and Sonar port details
  # and creates an `Mdm::Service`
  #
  # @param host [Mdm::Host] the Host to create the Service on
  # @param port [Integer] the port number to use for the `Mdm::Service`
  # @param proto [String] the transport protocol for the `Mdm::Service` (tcp/udp)
  # @return [Mdm::Service] the `Mdm::Service` representing all this data
  def create_service(host,port,proto)
    service = host.services.where(port: port, proto: proto).first_or_create!
    if service.state.nil?
      service.state = 'open'
      service.save!
    end
    service
  end

  # Takes a host's address and queries Sonar for any ports
  # it knows about on that host. It yields the port number
  # and transport protocol.
  #
  # @param address [String] the address of the host to find ports for
  # @yieldparam port_number [Integer] the port number
  # @yieldparam proto [String] the transport protocol used (tcp/udp)
  # @yieldreturn [void]
  def each_port_for_host(address)
    results = client.search(ports: address, limit: SONAR_QUERY_LIMIT)
    check_for_error(results)
    results.each do |result|
      next unless result[:collection]
      result[:collection].each do |port_record|
        port_string = port_record[:port].first
        port_string.gsub!(/^port-/,'')
        port_number, proto = port_string.split('/')
        yield port_number.to_i, proto
      end
    end
  end

  # Iterates through the selected {Sonar::Data::Fdns} records
  # still in the #import_run and creates {Mdm::Host} records with
  # attached notes for last_seen_date and any {Mdm::Tag} objects
  # to be associated with it.
  #
  # @yieldparam [Mdm::Host] the imported Host object
  # @yieldreturn [void]
  def each_selected_host
    import_run.fdns.each do |fdns|
      begin
        host_obj = create_host(fdns)
        create_last_seen_note(host_obj,fdns.last_seen)
        process_host_tags(host_obj)

        yield host_obj if block_given?
      rescue ActiveRecord::RecordInvalid => e
      else
        service_queue << host_obj.id
      end
    end
  end


  # @overload import
  #   Imports hosts and services from Sonar based on {#domain_name}.
  #
  #   @return [void]
  #
  # @overload import(&block)
  #   Imports hosts and services from Sonar based on {#import_run}.
  #
  #   @yieldparam host_or_service [Mdm::Host, Mdm::Service] the created
  #     `Mdm::Host` or `Mdm::Service`.
  #   @yieldreturn [void]
  #   @return [void]
  def import(&block)
    each_selected_host(&block)
    process_service_queue(&block)
  end

  # Takes the array of date strings from a Sonar
  # result and converts them all to {Date}s and returns
  # the most recent one
  #
  # @param collection_dates [Array<String>] The array of date strings to process
  # @return [Date] the most recent {Date} from the collection
  def last_seen(collection_dates)
    collection_dates = collection_dates.map { |date_string| Date.parse date_string }
    collection_dates.max
  end

  # Takes a host and calls #create_host_tag for each
  # tag supplied.
  #
  # @param host [Mdm::Host] the host to attach the tags to
  def process_host_tags(host)
    tags.each do |tag|
      create_host_tag(host,tag)
    end
  end

  # @overload process_service_queue
  #   For each `Mdm::Host#id` in the {#service_queue}, queries Sonar for the
  #   known `Mdm::Service#port` and `Mdm::Service#proto`, which are used to
  #   {#create_service create an `Mdm::Service`}.
  #
  #   @return [void]
  #
  # @overload process_service_queue(&block)
  #   For each `Mdm::Host#id` in the {#service_queue}, queries Sonar for the
  #   known `Mdm::Service#port` and `Mdm::Service#proto`, which are used to
  #   {#create_service create an `Mdm::Service`} that is then yielded to the
  #   `block`.
  #
  #   @yieldparam service [Mdm::Service] the created Mdm::Service
  #   @yieldreturn [void]
  #   @return [void]
  def process_service_queue
    until service_queue.empty? do
      host_id = service_queue.pop
      host_obj = Mdm::Host.find(host_id)
      address = host_obj.address
      ports_found = false
      each_port_for_host(address) do |port, proto|
        service_obj = create_service(host_obj, port, proto)
        ports_found = true
        yield service_obj if block_given?
      end
      if ports_found == false
        yield "No Ports found for #{address}" if block_given?
      end
    end
  end

  private

  # Holds the options hash for the Sonar client
  #
  # @return [Hash{ access_token: String, api_url: String, api_version: String, email: String }] the options hash to initialize the Sonar client
  def client_options
    sonar_account = SonarAccount.first
    {
      access_token: sonar_account.api_key,
      api_url: 'https://sonar.labs.rapid7.com',
      api_version: 'v2',
      email: sonar_account.email
    }
  end


end

