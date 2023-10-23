# A Metasploit-side representation of the Nexpose scan template that was applied to a group of
# assets managed by a Nexpose console.
class ::Nexpose::Data::ScanTemplate < ApplicationRecord

  #
  # Associations
  #
  # @!attribute console
  #   The Nexpose console this asset is associated with
  #
  #   @return [Nexpose::Data::Console]
  belongs_to :console,
             class_name:"Mdm::NexposeConsole",
             foreign_key: :nx_console_id

  #
  # Validations
  #
  validates :nx_console_id,
            numericality: true,
            presence: true
  
  scope :scan_template_id, lambda { |site_id| where(scan_template_id: site_id) }
  
  delegate :get, to: :console, prefix: true

  #
  # Rails 4 compatibility, manually create accessible attributes
  #
  ACCESSIBLE_ATTRS = [
    'console',
    'name',
    'nx_console_id',
    'scan_template_id'
  ]

  # A Ruby representation of the object retrieved from the Nexpose API
  # @param object_attributes [Hash] the deserialized JSON
  # @return [Nexpose::Data::ScanTemplate]
  def self.object_from_json(object_attributes)
    scan_template_attributes = object_attributes.slice(*ACCESSIBLE_ATTRS)
    scan_template = scan_template_id(scan_template_attributes["scan_template_id"]).
      first_or_create(scan_template_attributes)
    scan_template
  end
  
end
