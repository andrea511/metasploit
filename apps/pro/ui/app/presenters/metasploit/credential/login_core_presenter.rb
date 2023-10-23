module Metasploit
  module Credential

    class LoginCorePresenter < LoginPresenter
      def as_json(opts = {})
        json = super
        json.merge!({
          core: {
            public:{
              username: core.public.try(:username)
            },
            private:{
              data: core.private.try(:data),
              data_truncated: private_data_truncated
            },
            pretty_realm: pretty_realm,
            realm: {
              key:   core.realm.try(:key),
              value: core.realm.try(:value)
            }
          }
        })
      end
    end

  end
end
