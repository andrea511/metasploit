# Wizards::BaseForm subclasses are used as "container" classes for the snowball of data
# passed to the wizard by the user. The BaseForm subclass is then acted upon by a 
# Wizards::BaseBuilder subclass, which converts the user's POST parameters into
# TaskConfig subclasses, which are then stored back in the BaseForm.
#
# The BaseForm is then passed to a Wizards::BaseValidator subclass, then finally over to a
# Procedure, which saves away the configuration (by calling #config_to_hash on all of the
# TaskConfigs) and starts the CommanderTask.
#
# Phew.
class Wizards::BaseForm < Custom::FormtasticFauxModel
  include Metasploit::Pro::AttrAccessor::Boolean

  # maintain a list of accessors for use in the to_hash method
  # we don't get this for free from FormtasticFauxModel :(
  def self.attributes
    @attributes ||= []
  end

  def self.attr_accessor(name)
    attributes << name
    super(name)
  end

  # set only first-level "glue" attributes
  def initialize(attrs={})
    attrs.each do |key, val|
      setter = "#{key}="
      send(setter, val) if self.respond_to?(setter)
    end
  end

  # convert our QuickPentest FormtasticFauxModel into a hash, for
  #  throwing over to our Procedure class to execute.
  def to_hash(opts={})
    hash = {}
    self.class.attributes.each do |attribute|
      value = self.send(attribute)
      if value.is_a?(TaskConfig) && value.respond_to?(:config_to_hash)
        hash[attribute] = value.config_to_hash
      else
        hash[attribute] = value
      end
    end
    hash
  end

end
