# Explicitly require carrierwave so mount_uploader is defined for prosvc
require 'carrierwave/orm/activerecord'

# Stores either the {#text textual} or {#image graphical} proof of a Mdm::WebVuln.  This is a Pro-only extension to
# the Mdm::WebVuln#proof field so that images can be handled in addition to the textual proof that was handled by the
# deprecated Mdm::WebVuln#proof.
class Web::Proof < ApplicationRecord
  self.table_name = 'web_proofs'

  #
  # Associations
  #

  # @!attribute [rw] vuln
  #   The web vulnerability being proven by the {#image} or {#text}
  #
  #   @return [Mdm::WebVuln]
  belongs_to :vuln, :class_name => 'Mdm::WebVuln'

  #
  # Attributes
  #

  # @!attribute [rw] text
  #   Textual proof of the {#vuln}.
  #
  #   @return [nil] if the proof is {#image graphical} only.
  #   @return [String] if proof is textual

  #
  # Uploader Mounts
  #

  # @!attribute image [rw]
  #   Screen shot of the vulnerability being exploited on the web page.
  #
  #   @return [ImageUploader]
  mount_uploader :image, ImageUploader

  #
  # Validations
  #

  validates :vuln, :presence => true
  validate :content_present

  private

  # Validates that {#image}, {#text}, or both are present.
  #
  # @return [void]
  def content_present
    unless image.present? or text.present?
      errors.add(:base, 'has no content (image or text)')
    end
  end
end
