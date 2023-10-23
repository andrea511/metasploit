module Metasploit
  module Credential
    class CorePresenter < DelegateClass(Core)
      include ActionView::Helpers

      def private_data_truncated
        private.try(:to_s).try(:truncate, 25)
      end

      # Generate a form of the origin suitable for display.
      #
      # return [String] the HTML for the origin cell
      def pretty_origin
        origin_type.constantize.model_name.human
      end

      # @return [String] a validation status message
      def validated
        # TODO: Have to do this in memory, since a logins.count would cause an additional query.
        # Which is worse?
        if logins.any? { |login| login.status == Metasploit::Model::Login::Status::SUCCESSFUL }
          "Validated"
        else
          "Not Validated"
        end
      end

      # @return [String] the realm for this credential
      def pretty_realm
        "#{realm.value} (#{realm.key})" if realm
      end

      # @return [String] a key version of the private type for building option menus
      def type_key
        case private
        when NilClass
          'none'
        when Metasploit::Credential::SSHKey
          'ssh'
        when Metasploit::Credential::PasswordHash || Metasploit::Credential::ReplayableHash
          'hash'
        when Metasploit::Credential::NTLMHash
          'ntlm'
        when Metasploit::Credential::Password
          'plaintext'
        end
      end

      def as_json(opts = {})
        {
          id:               id,
          logins_count:     logins_count,
          public: {
            username:       public.try(:username)
          },
          private: {
            data:             private.try(:data).try(:to_s),
            full_fingerprint: (type_key == 'ssh' ? private.try(:to_s) : nil),
            data_truncated:   private_data_truncated,
            type:             type_key,
            class:            private.try(:class).try(:to_s)
          },
          realm: {
            key:            realm.try(:key),
            value:          realm.try(:value)
          },
          pretty_realm:     pretty_realm,
          tag_count:        tags.size,
          origin:           pretty_origin,
          origin_url:       Rails.application.routes.url_helpers.workspace_metasploit_credential_core_origin_path(workspace_id, id, format: :json),
          validation:       validated,
          pretty_type:      private.try(:class).try(:model_name).try(:human),
          tagUrl:           Rails.application.routes.url_helpers.quick_multi_tag_workspace_metasploit_credential_cores_path(workspace_id, format: :json),
          created_at:       created_at
        }
      end
    end

  end
end