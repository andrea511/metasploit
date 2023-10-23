class Apps::PassTheHash::TaskConfigController < Apps::BaseController
  def show_smb_hashes
    respond_to do |format|
      format.json {
        # finder = Apps::PassTheHash::PassTheHashFinder.new(@workspace)
        relation = Metasploit::Credential::Core.data_tables
                    .where(
                      workspace_id: @workspace.id,
                      metasploit_credential_privates: {type: ['Metasploit::Credential::NTLMHash', 'Metasploit::Credential::PostgresMD5' ]})
        
        render :json => DataTableQueryResponse.build(params, {
          :collection => relation,
          :columns => [:id, :domain, :username, :password, :created_at],
          :virtual_columns => [:domain, :username, :password]
        })
      }
    end
  end

  private

  def set_report_type
    @report_type = Apps::PassTheHash::TaskConfig::REPORT_TYPE
  end
end
