class SSLCert < ApplicationRecord
  #
  # Associations
  #

  belongs_to :workspace, :class_name => 'Mdm::Workspace'

  #
  # Validations
  #
  mount_uploader :file, SSLCertUploader
  validates :file, :presence => true
  validates :workspace_id, :presence => true
  validate :valid_cert?
  validate :has_clear_key?

  # Returns the cert as a {OpenSSL::X509::Certificate}
  # to be parsed and processed easily inside ruby code.
  #
  # @return [OpenSSL::X509::Certificate] the X509 Certificate object
  def to_x509
    if self.file.file.present?
      OpenSSL::X509::Certificate.new self.file.file.read
    else
      nil
    end
  end

  def valid_cert?
    if self.file.file.present?
      begin
        OpenSSL::X509::Certificate.new self.file.file.read
      rescue OpenSSL::X509::CertificateError => e
        errors.add(:base, e.message)
      end
    end
  end

  def has_clear_key?
    if self.file.file.present?
      begin
        OpenSSL::PKey::RSA.new self.file.file.read, ""
      rescue OpenSSL::PKey::RSAError => e
        errors.add(:base, e.message)
      end
    end
  end
end
