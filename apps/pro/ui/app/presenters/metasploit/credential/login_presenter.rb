module Metasploit
  module Credential
    class LoginPresenter < DelegateClass(Login)
      include ActionView::Helpers

      def private_data_truncated
        core.private.try(:data).try(:truncate, 25)
      end

      # @return [String] the realm for this credential
      def pretty_realm
        "#{core.realm.key} (#{core.realm.value})" if core.realm
      end

      def as_json(opts = {})
        overwrite_service = opts.fetch(:overwrite_service, true)

        json = super

        if overwrite_service
          json.merge!({
            service: {
              id: service.id,
              name: service.name,
              port: service.port,
              host: {
                  name: (service.host.name.blank? ? service.host.address : service.host.name), # if name is null fill name field with address so that name is never blank
                id: service.host.id
              }
            }
          })
        end

        json.merge!({
          workspace_id: core.workspace.id,
          last_attempted_at: last_attempted_at.try(:strftime, "%Y-%m-%d %T %z"),
          tag_count: tags.size,
          tagUrl:  Rails.application.routes.url_helpers.quick_multi_tag_workspace_metasploit_credential_core_logins_path(core.workspace.id, core_id, format: :json)
        })
      end
    end

  end
end
