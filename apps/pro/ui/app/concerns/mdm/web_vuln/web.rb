module Mdm::WebVuln::Web
  extend ActiveSupport::Concern

  included do
    #
    # Associations
    #

    # @!attribute [rw] category
    #   @return [Web::VulnCategory::Metasploit] the metasploit category for this vulnerability.
    belongs_to :category, :class_name => 'Web::VulnCategory::Metasploit'

    # @!attribute [rw] proofs
    #   @return [Array<Web::Proof>] {Web::Proof#text Textual} and/or {Web::Proof#image graphical} proof of this
    #     vulnerability.
    has_many :proofs, :class_name => 'Web::Proof', :dependent => :destroy, :foreign_key => :vuln_id

    # @!attribute [rw] request
    #   @return [Web::Request] if this web vuln is either found or verified by a {Web::Request}
    #   @return [nil] if this web vuln is associated with a Mdm::WebSite
    belongs_to :request, :class_name => 'Web::Request', optional: true

    #
    # Validations
    #

    validate :consistent_categories
    validate :category_or_legacy_category
    validate :request_xor_web_site

    # Removes validates :category, :presence => true
    # and validates :proof, :presence => true

    chain = _validate_callbacks

    filtered_chain = chain.dup

    chain.each do |callback|
      # raw_filter removed https://github.com/rails/rails/pull/41598
      filter = callback.filter
      if filter.is_a? ActiveModel::Validations::PresenceValidator
        attributes = filter.attributes

        [:category, :proof].each do |attribute|
          if attributes.include? attribute
            filtered_chain.delete(callback)
          end
        end
      end
    end

    self._validate_callbacks = filtered_chain
  end

  # Mimics the old proof attribute for use as a shim with old views that don't support multiple proofs or non-textual
  # proofs.
  #
  # @return [nil] if there is no proofs with text
  # @return [String] if there is an {Web::Proof} with {Web::Proof#text} in proofs.
  #
  # @deprecated Update your usage to use Mdm::WebVuln#proofs and handle {Web::Proof#text textual} and
  #   {Web::Proof#image graphical} proof.
  def proof
    table = ::Web::Proof.arel_table
    query = proofs.where(
        table[:text].not_eq(nil)
    )
    textual_proof = query.first

    proof = nil

    if textual_proof
      proof = textual_proof.text
    end

    proof
  end

  private

  # Records an error if category.name and legacy_category are both present and not the same
  #
  # @return [void]
  def consistent_categories
    if category.present? and legacy_category.present? and category.name != legacy_category
      errors.add(:base, 'category.name does not match legacy_category')
    end
  end

  # Records an error against :base if both #category and #legacy_category are not present.
  #
  # @return [void]
  def category_or_legacy_category
    unless category.present? or legacy_category.present?
      errors.add(:base, "can't have both category and legacy_category blank")
    end
  end

  # Records an error against :base if either #request or #web_site is not present, or if both are present.
  #
  # @return [void]
  def request_xor_web_site
    unless request.present? ^ web_site.present?
      errors.add(:base, 'can have either request or web_site present, but not both')
    end
  end
end
