class Apps::SshKey::TaskConfigController < Apps::BaseController
  # datatable response action
  def show_ssh_keys
    respond_to do |format|
      format.json {
        # finder = Apps::SshKey::SshKeyFinder.new(@workspace)
        relation = Metasploit::Credential::Core.data_tables
                    .where(
                      workspace_id: @workspace.id,
                      metasploit_credential_privates: {type: 'Metasploit::Credential::SSHKey'})

        render :json => DataTableQueryResponse.build(configs_params, {
          :collection => relation,
          :columns => [:id, :username, :password, :created_at],
          :virtual_columns => [:username, :password]
        })

      }
    end
  end

  private

  def set_report_type
    @report_type = Apps::SshKey::TaskConfig::REPORT_TYPE
  end

  def configs_params
    params.permit!
  end
end
