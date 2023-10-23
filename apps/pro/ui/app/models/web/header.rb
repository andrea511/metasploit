# Headers sent as part of a {Web::Request}.  There can be multiple {Web::Header} with the same {#name} for the same
# {Web::Request}.  The order of these same named {Web::Header Web::Headers} can be determined with the {#position}
# attribute which can be manipulated with acts_as_list.  The `'Cookie'` header is not stored as {Web::Header}, but
# instead as individual {Web::Cookie Web::Cookies} for each cookie name=value pair that would be in the `'Cookie'`
# header.  {#attack_vector} should be `true` if the header's {#value} (or {#name}) is manipulated as part of an attack
# and `false` if the header is not being manipulated.
class Web::Header < ApplicationRecord
  include Web::AttackVector

  #
  # Acts as ...
  #

  acts_as_list :scope => :request_group

  #
  # Associations
  #

  # @!attribute [rw] request
  #   @return [Web::Request] request where this header is sent.
  belongs_to :request_group, :class_name => 'Web::RequestGroup'

  #
  # Attributes
  #

  # @!attribute [rw] attack_vector
  #   @return [true] if this parameter's {#name} or {#value} was manipulated as part of an attack.
  #   @return [false] if this parameter's {#name} or {#value} was submitted without alteration.

  # @!attribute [rw] name
  #   @return [String] name of the header

  # @!attribute [rw] position
  #   @return [Integer] the position of the header relative to other headers for the same {#request}.

  # @!attribute [rw] value
  #   @return [String] the value of the header.

  #
  # Validations
  #

  validates :name, :presence => true
  validates :request_group, :presence => true
  validates :value, :presence => true
end
