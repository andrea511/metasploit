module Metasploit
  module Credential
    class OriginPresenter
      include ActionView::Helpers

      attr_accessor :origin

      def initialize(origin)
        @origin = origin
      end

      def pretty_origin
        case @origin
        when Metasploit::Credential::Origin::Import
          render_import_origin_cell
        when Metasploit::Credential::Origin::Manual
          render_manual_origin_cell
        when Metasploit::Credential::Origin::Service
          render_service_origin_cell
        when Metasploit::Credential::Origin::Session
          render_session_origin_cell
        when Metasploit::Credential::Origin::CrackedPassword
          render_cracked_password_origin_cell
        end
      end

      # @return [String] the markup for an import origin table tell
      def render_import_origin_cell
        "Import of #{@origin.filename}"
      end

      # @return [String] the markup for a manual origin table tell
      def render_manual_origin_cell
        "Created by #{@origin.user.username} on #{l(@origin.created_at, format: :short_datetime)}"
      end

      # @return [String] the markup for a service origin table tell
      def render_service_origin_cell
        link_to "#{@origin.service.host.address} #{@origin.service.name}", Rails.application.routes.url_helpers.host_path(@origin.service.host.id)
      end

      # @return [String] the markup for a session origin table tell
      def render_session_origin_cell
        link_to "#{@origin.session.host.address} #{@origin.post_reference_name}", Rails.application.routes.url_helpers.session_path(@origin.session.workspace, @origin.session)
      end

      # @return [String] the markup for a cracked password origin table cell
      def render_cracked_password_origin_cell
        "Cracked password from " + link_to("this credential", "#creds/#{@origin.originating_core.id}")
      end

      # TODO: Eventually there will be a Bruteforce origin type (for
      # when we guess )

      def as_json(opts = {})
        {
          pretty_origin: pretty_origin
        }
      end
    end
  end
end