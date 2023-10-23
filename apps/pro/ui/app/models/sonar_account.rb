# Account information used to login to the Sonar Web Service
# [Sonar](http://sonar.labs.rapid7.com/)
class SonarAccount < ApplicationRecord

  #
  # Attributes
  #

  # @!attribute created_at
  #   When this client was created.
  #
  #   @return [DateTime]

  # @!attribute updated_at
  #   When this client was last updated.
  #
  #   @return [DateTime]

  # @!attribute api_key
  #   The API key used to login to Sonar
  #
  #   @return [String]

  # @!attribute email
  #   The e-mail address used to login to Sonar
  #
  #   @return [String]

  validates_presence_of :api_key
  validates_presence_of :email
end
