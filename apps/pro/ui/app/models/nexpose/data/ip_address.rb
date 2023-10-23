# This class is used to normalize the IP data available for a {Nexpose::Data::Asset}.
# Nexpose allows assets to have more than one IP address associated. This is where they live
# once they are imported.
class ::Nexpose::Data::IpAddress < ApplicationRecord

  #
  # Attributes
  #

  # @!attribute [rw] asset_ip_address
  #   The IP address. Necessary to avoid coercion to an `IPAddr` object.
  #
  #   @return [String]
  def asset_ip_address
    self[:asset_ip_address].to_s
  end


  # @!attribute nexpose_asset
  #   The Nexpose asset this IP is associated with
  #
  #   @return [Nexpose::Data::Asset]
  belongs_to :nexpose_asset,
             class_name:"::Nexpose::Data::Asset",
             optional: true, # optional to allow for serialization of Nexpose::Data::Asset from json
             foreign_key: :nexpose_data_asset_id

end
