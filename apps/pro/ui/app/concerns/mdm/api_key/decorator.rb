module Mdm::ApiKey::Decorator
  extend ActiveSupport::Concern

  included do
    validates :name, :presence => true

    # @return[String] a valid token string for the API
    def self.generated_token
      Rex::Text.md5( Rex::Text.rand_text(128) )
    end
  end


  # @return [String] obfuscated token for display
  def obfuscated_token
    token[0..3] + "****************************"
  end
end

