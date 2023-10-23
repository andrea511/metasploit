module Metasploit::Pro::AttrAccessor::Addresses
  extend ActiveSupport::Concern

  include ActiveModel::Validations

  #
  # CONSTANTS
  #

  # Tags must start with '#'
  TAG_REGEX = /^#(?<tag_name>.*)/

  module ClassMethods
    def addresses_attr_accessor(attribute_name)
      addresses_attribute_name_set.add(attribute_name)

      instance_variable = "@#{attribute_name}".to_sym

      #
      # Validations
      #

      validates attribute_name, :ip_range_enumeration => true

      #
      # Instance Methods
      #

      define_method(attribute_name) do
        value = instance_variable_get(instance_variable)

        unless value
          value = []
          instance_variable_set(instance_variable, value)
        end

        value
      end

      setter = "#{attribute_name}="

      define_method(setter) do |raw_value|
        parsable_value = raw_value || []
        value = tags_and_addresses(parsable_value)

        instance_variable_set(instance_variable, value)
      end

      string_getter = "#{attribute_name}_string".to_sym

      define_method(string_getter) do
        send(attribute_name).join("\n")
      end

      string_setter = "#{string_getter}="

      define_method(string_setter) do |string|
        unless string.blank?
          value = string.to_s.split(/\s+/)
          send(setter, value)
        end

      end
    end

    def addresses_attribute_name_set
      @addresses_attribute_name_set ||= Set.new
    end
  end

  #
  # Instance Methods
  #

  # Renders host address along with scope
  #
  # @param host [Mdm::Host]
  # @return [String] `host.address` if `host` does not have a scope
  # @return [String] "<address>%<scope>" if `host` does have a scope
  def scope_address(host)
    if host.scope
      scoped_address = "#{host.address}%#{host.scope}"
    else
      scoped_address = host.address
    end

    scoped_address
  end

  # Returns the addresses of host with the given tag.
  #
  # @note tags will be ignored and an empty Set returned if the license does not support tags.
  #
  # @param tag_name [String] name of tag.  Can be extracted from potential tag or address using {#tag_name}.
  # @return [Set<String>] a set of addresses
  #
  # @see #tag_name
  # @see License#supports_tags?
  def tag_addresses(tag_name)
    address_set = Set.new

    if tag_name.present?
      if tag_name == 'all'
        workspace.hosts.find_each do |host|
          scoped_address = scope_address(host)
          address_set.add scoped_address
        end
      else
        tags = Mdm::Tag.where(:name => tag_name)

        tags.find_each do |tag|
          hosts = tag.hosts.where(:workspace_id => workspace.id)

          hosts.find_each do |host|
            scoped_address = scope_address(host)
            address_set.add scoped_address
          end
        end
      end
    end

    address_set
  end

  # Returns name of tag without tag prefix ('#')
  #
  # @param potential [String] a tag or address
  # @return [nil] if potential does not start with '#'
  # @return [String] if potential starts with '#'
  #
  # @see TAG_REGEX
  def tag_name(potential)
    tag_name = nil
    match = TAG_REGEX.match(potential)

    if match
      tag_name = match[:tag_name]
    end

    tag_name
  end

  # Resolves tags to associated hosts, sorts the list,
  # and passes through any non-tags for further validation.
  #
  # @return [Array<String>]
  def tags_and_addresses(words=[])
    if words.is_a? Array
      resolved_address_set = Set.new

      words.each do |word|
        tag_name = self.tag_name(word)

        if tag_name
          tag_addresses = self.tag_addresses(tag_name)
          resolved_address_set.merge(tag_addresses)
        else
          resolved_address_set.add word # Validator deals with these
        end
      end

      address_sort(resolved_address_set)
    else
      words
    end
  end

  private

  # Sort addresses and address ranges. Note that this should make
  # no attempt to kick out invalid or unresolvable addresses. If we did,
  # we couldn't let the user know which address was bad in any normal
  # flash @error sort of way.
  def address_sort(address_ranges)
    address_ranges.sort do |a,b|
      ip_a = Rex::Socket.addr_atoi(a) rescue a.to_i
      ip_b = Rex::Socket.addr_atoi(b) rescue b.to_i

      if [ip_a,ip_b].include? 0 # Couldn't resolve, so one is a non-ipaddr
        a.to_s <=> b.to_s
      else
        ip_a <=> ip_b
      end
    end
  end
end