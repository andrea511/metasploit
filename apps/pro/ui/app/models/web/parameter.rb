# GET and POST parameters for requests.
#
# In a URL like 'http://example.com?name=value', `'name'` would be the {#name} amd `'value'` would be the {#value}.
# {#attack_vector} should be set to `true` if the parameter is being used for a XSS or other attack as opposed to just
# be submitted as a normal parameter to make the targeted {Web::VirtualHost} respond.
class Web::Parameter < ApplicationRecord
  include Web::AttackVector
  #
  # Acts as ...
  #

  acts_as_list :scope => :request

  #
  # Associations
  #

  # @!attribute [rw] request
  #   @return [Web::Request] request where this parameter was a part of the GET query or www-form-encoded body.
  belongs_to :request, :class_name => 'Web::Request'

  #
  # Attributes
  #

  # @!attribute [rw] attack_vector
  #   @return [true] if this parameter's {#value} was manipulated as part of an attack.
  #   @return [false] if this parameter's {#value} was submitted without alteration

  # @!attribute [rw] name
  #   @return [String] name of the parameter

  # @!attribute [rw] position
  #   @return [Integer] the position of the parameter relative to other parameters for the same {#request}.

  # @!attribute [rw] value
  #   @return [String] the value of the parameter.  Will be `''` if the GET query was like `'&name='` with no value
  #     after the `'='`

  #
  # Validations
  #

  validates :name, :presence => true
  validates :request, :presence => true
  validates :value, :not_nil => true

end
