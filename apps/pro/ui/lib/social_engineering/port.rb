module SocialEngineering::Port
  extend ActiveSupport::Concern

  include ActiveModel::Validations

  #
  # CONSTANTS
  #

  # Number of bits used to address ports
  PORT_BITS = 16
  # The max number of ports
  PORT_LIMIT = 2 ** PORT_BITS
  # The range of assignable port numbers.  0-indexed, so it does not include {PORT_LIMIT}.
  PORT_RANGE = (0 ... PORT_LIMIT)

  included do
    validate :no_port_collisions
  end

  module ClassMethods
    def port_title_by_attribute_name
      @port_title_by_attribute_name ||= {}
    end

    def validates_port(attribute_name_prefix, title_prefix=nil)
      attribute_name = "#{attribute_name_prefix}_port".to_sym

      title_prefix ||= attribute_name_prefix.to_s.titleize
      title = "#{title_prefix} Port"

      @port_title_by_attribute_name ||= {}
      @port_title_by_attribute_name[attribute_name] = title

      validates attribute_name,
                :allow_blank => true,
                :inclusion => {
                    :in => PORT_RANGE,
                    :message => "must be between #{PORT_RANGE.min} and #{PORT_RANGE.max}"
                },
                :numericality => {
                    :only_integer => true
                }
    end
  end

  #
  # Instance Methods
  #

  private

  def no_port_collisions
    pairs_by_port = self.class.port_title_by_attribute_name.group_by { |attribute_name, _|
      send(attribute_name)
    }

    pairs_by_port.each do |port, pairs|
      # if not blank and more than one port is using the same port number
      if port.present? and pairs.length > 1
        titles = pairs.collect { |pair|
          pair[1]
        }
        title_sentence = titles.to_sentence

        errors.add :base, "port collision between #{title_sentence} on port #{port}"
      end
    end
  end
end
