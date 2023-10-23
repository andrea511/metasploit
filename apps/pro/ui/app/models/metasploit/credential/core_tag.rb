class Metasploit::Credential::CoreTag < ApplicationRecord
  self.table_name = "metasploit_credential_core_tags"

  #
  # Validations
  #

  validates_presence_of :credential_core, :tag
  validates_uniqueness_of :tag_id, scope: [:core_id]

  #
  # Associations
  #

  # @!attribute credential_core
  #   The {Metasploit::Credential::Core}
  #
  #   @return [Metasploit::Credential::Core, nil]
  belongs_to :credential_core,
             class_name: 'Metasploit::Credential::Core',
             foreign_key: 'core_id',
             inverse_of: :credential_core_tags

  # @!attribute tag
  #   The {Mdm::Tag}
  #
  #   @return [Mdm::Tag, nil]
  belongs_to :tag,
             class_name: 'Mdm::Tag',
             inverse_of: :credential_core_tags

  #
  # Callbacks
  #

  # @see http://stackoverflow.com/a/11694704
  after_destroy :destroy_orphan_tag

  private

  # Destroys {#tag} if it is orphaned
  #
  # @see http://stackoverflow.com/a/11694704
  # @return [void]
  def destroy_orphan_tag
    # ensure fresh load of tag record
    # in theory this will always return one result safe navigation is just "extra"
    Mdm::Tag.where(id: tag.id).first&.destroy_if_orphaned
  end


  public

  Metasploit::Concern.run(self)
end

