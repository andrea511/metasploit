# The HostFinder is responsible for doing our initial query
# to [Sonar](https://sonar.labs.rapid7.com) and finding all
# of the hosts that match our search criteria.
class Metasploit::Pro::Engine::Sonar::HostFinder

  # @return [String] the domain name to start the search with
  attr_accessor :domain_name
  # @return [Integer] the number of days to limit the search to
  attr_accessor :last_seen_days


  def initialize(domain_name: , last_seen_days: 30)
    @domain_name    = domain_name
    @last_seen_days = last_seen_days
  end

  # Builds the options hash for the {Sonar::Client} based
  # on the {SonarAccount}
  #
  # @return [Hash] the options hash to set up the {Sonar::Client}
  def client_options
    account = SonarAccount.first
    raise Metasploit::Pro::Engine::Sonar::Error, 'No Valid Sonar Account found' if account.nil?
    {
      access_token: account.api_key,
      api_url:      'https://sonar.labs.rapid7.com',
      api_version:  'v2',
      email:        account.email
    }
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

  # Queries the Sonar API and yields a hash representing
  # each host record
  #
  # @yieldparam host_hash [Hash{ address: String, name: String, last_seen: Date}] The hash record for the host
  # @yieldreturn [void]
  def each_sonar_host
    domain_variants = [ domain_name, ".#{domain_name}"]
    domain_variants.each do |domain|
      results = sonar_client.search(fdns: domain, limit: Metasploit::Pro::Engine::Sonar::QUERY_LIMIT)
      check_for_error(results)
      results.each do |result|
        result[:collection].each do |host_record|
          next if sloppy_match?(host_record[:name])
          last_seen_date = last_seen(host_record[:sources])
          next unless within_window?(last_seen_date,last_seen_days)
          host_hash = {
            name: host_record[:name],
            address: host_record[:address],
            last_seen: last_seen_date
          }
          yield host_hash
        end
      end
    end
  end

  # Takes the array of date strings from a Sonar
  # result and converts them all to {Date}s and returns
  # the most recent one
  #
  # @param collection_dates [Array<String>] The array of date strings to process
  # @return [Date] the most recent {Date} from the collection
  def last_seen(collection_dates)
    collection_dates = collection_dates.map { |date_string| Date.parse date_string.to_s }
    collection_dates.max
  end

  # The Sonar API search does a contains style search. This
  # can lead to sloppy match results. This method checks if we have
  # a sloppy match so we can filter those results out.
  #
  # @param hostname [String] the hostname for the search result
  # @return [true] if the hostname is a sloppy match
  # @return [false] if the hostname is a legitimate match
  def sloppy_match?(hostname)
    if hostname.match(/^(?:.+\.)?#{domain_name}$/)
      false
    else
      true
    end
  end

  # @return [Sonar::Client] the Sonar Client used to talk to Sonar
  def sonar_client
    @sonar_client ||= Sonar::Client.new(client_options)
  end

  # Takes the most recent date and a number of days and sees if that
  # date was no more than that number of days ago.
  #
  # @param most_recent [Date] the last Date the host was seen on
  # @param window [Integer]  the number of days that date must be within
  # @return [TrueClass] if the date is within the window
  # @return [FalseClass] if the date is NOT within the window
  def within_window?(most_recent,window)
    return true if window.nil?
    today = Date.today
    days_since_last_seen = (today - most_recent).to_i
    days_since_last_seen <= window
  end

end
