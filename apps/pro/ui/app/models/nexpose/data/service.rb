# This class is used to enumerate the servies for a {Nexpose::Data::Asset}.
# Nexpose lists services that are both vulnerable and non-vulnerable.
class ::Nexpose::Data::Service < ApplicationRecord

  #
  # Attributes
  #

  # @!attribute nexpose_asset
  #   The Nexpose asset this Service is associated with
  #
  #   @return [Nexpose::Data::Asset]
  belongs_to :nexpose_asset,
             class_name:"::Nexpose::Data::Asset",
             foreign_key: :nexpose_data_asset_id

end
