class Apps::SinglePassword::TaskConfigController < Apps::BaseController
  def show_creds
    respond_to do |format|
      format.json do
        relation = Metasploit::Credential::Core.data_tables.where(workspace_id: @workspace.id)
        
        render :json => DataTableQueryResponse.build(params, {
          :collection => relation,
          :columns => [:id, :domain, :username, :password, :created_at],
          :virtual_columns => [:domain, :username, :password]
        })

      end
    end
  end

  private

  def set_report_type
    @report_type = Apps::SinglePassword::TaskConfig::REPORT_TYPE
  end
end
