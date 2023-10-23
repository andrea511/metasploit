require 'memoist'
require 'metasploit/pro/host_selection'
module BruteForce
  module Quick

    # The Target Selector is responsible for taking input from the Quick Bruteforce form
    # and making decisions about what services should be targeted.
    class TargetSelector
      extend Memoist

      # @!attribute :blacklist_hosts
      #   @return [String] any hosts to be explicitly excluded as targets
      attr_accessor :blacklist_hosts
      # @!attribute :services
      #   @return [Hash] a hash showing which specific service types to target
      attr_accessor :services
      # @!attribute :whitelist_hosts
      #   @return [String] any hosts to be explicitly included as targets
      attr_accessor :whitelist_hosts
      # @!attribute :workspace
      #   @return [Mdm::Workspace] the workspace in which to find the targets
      attr_accessor :workspace

      # @param attributes [Hash{Symbol => String,nil}]
      def initialize(attributes={})
        attributes.each do |attribute, value|
          public_send("#{attribute}=", value)
        end
      end

      # Returns the service names to search the target hosts for to find the appropriate
      # target services.
      #
      # @return [Array<String>] an array of service names
      def allowed_names
        allowed_scanners.map { |scanner| scanner.const_get(:LIKELY_SERVICE_NAMES) }.flatten.uniq
      end
      memoize :allowed_names

      # Returns the ports to search the target hosts for to find the appropriate
      # target services.
      #
      # @return [Array<Integer>] an array of port numbers
      def allowed_ports
        allowed_scanners.map { |scanner| scanner.const_get(:LIKELY_PORTS) }.flatten.uniq
      end
      memoize :allowed_ports

      # Returns an array of allowed LoginScanner classes based on the selected services
      #
      # @return [Array<Class>] an array of LoginScanner classes
      def allowed_scanners
        allowed_services.map { |fake_service| Metasploit::Framework::LoginScanner.classes_for_service(fake_service) }.flatten.uniq
      end
      memoize :allowed_scanners

      # Returns fake Mdm::Service objects to find compatible LoginScanners with.
      # Returns one unsaved Service for each service type enabled.
      #
      # @return [Array<Mdm::Service>] the array of allowed service types
      def allowed_services
        names= services.keys.reject { |key| services[key] == false }
        names.map { |name| Mdm::Service.new(name: name.downcase) }
      end

      # Returns a Relation of Mdm::Host objects that match the selection criteria
      #
      # @return [ActiveRecord::Relation] the matching Target Hosts
      def target_hosts
        Metasploit::Pro::HostSelection.hosts_from_form(blacklist_hosts,whitelist_hosts,workspace)
      end
      memoize :target_hosts

      # Returns a Relation of Mdm::Service objects that match the selection criteria
      #
      # @return [ActiveRecord::Relation] the matching Target Services
      def target_services
        host_ids = target_hosts.to_a.map{ |host| host.id }
        query = Mdm::Service.where(Mdm::Service[:port].in(allowed_ports).or(Mdm::Service[:name].in(allowed_names)))
        query = query.where.not(Mdm::Service[:port].in([139]))
        query.where(Mdm::Service[:host_id].in(host_ids))
      end

    end
  end
end
