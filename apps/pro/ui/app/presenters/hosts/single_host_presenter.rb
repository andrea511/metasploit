class Hosts::SingleHostPresenter
  attr_reader :host
  attr_reader :controller

  # @param [Hash] opts the options to create the Presenter with
  # @option opts [Mdm::Host] :host
  # @option opts [HostsController] :controller
  # @option opts [Array<Mdm::Module::Detail>] :exploits array of matching exploits. defaults to empty relation.
  def initialize(opts={})
    @host = opts.fetch(:host)
    @controller = opts.fetch(:controller)
    @exploits = opts.fetch(:exploits, Mdm::Module::Detail.limit(0)) # empty relation
    @view_context = controller.view_context
  end

  # @return [Hash] ready for serializing into JSON
  def as_json
    {
      :tab_counts => {
        :services => host.service_count,
        :sessions => host.sessions.count,
        :credentials => credentials_count,
        :notes => host.note_count,
        :attempts => host.exploit_attempt_count,
        :modules => @exploits.count,
        :captured_data => host.loots.count,
        :file_shares => file_shares_count,
        :vulnerabilities => host.vuln_count,
        :web_vulnerabilities => host.web_vulns.count,
        :history => host.history_count
      },
      :host => {
        :address => host.address,
        :name => host.name,
        :status => status,
        :os_icon => os_icon,
        :virtual_host => virtual_host,
        :os => host.os,
        :os_name => host.os_name,
        :os_sp => host.os_sp,
        :os_flavor => host.os_flavor,
        :tags => host.tags,
        :id => host.id,
        :workspace_id => host.workspace_id,
        :host_details => host.host_details,
        :vpn_pivot => host.vpn_pivot,
        :mac => host.mac,
        :purpose => host.purpose,
        :comments => host.comments
      }
    }
  end

  def credentials_count
    Metasploit::Credential::Core.login_host_id(@host.id).count +
      Metasploit::Credential::Core.originating_host_id(@host.id).count
  end

  # Looks inside the file share's data structure to count the actual shares
  # An smb_share or nfs_export is one service with multiple shares/exports
  # @return [Integer] number of file shares
  def file_shares_count
    smb_shares = host.smb_shares.to_a.sum do |si|
      if si.data[:shares].kind_of? Array
        si.data[:shares].length
      end
    end
    nfs_shares = host.nfs_exports.to_a.sum do |si|
      if si.data[:exports].kind_of? Array
        si.data[:exports].length
      end
    end
    smb_shares + nfs_shares
  end

  # @return [String] rendered host status
  def status
    @view_context.host_status_text(host)
  end

  # @return [String] html containing an <img> for the host
  def os_icon
    @view_context.host_os_icon_html(host, json: false)
  end

  # @return [String] html containing an <img> for the VM (if applicable)
  def virtual_host
    @view_context.host_os_virtual_html(host, json: false)
  end
end
