require 'spec_helper'

RSpec.describe  Apps::Domino::TaskConfigController, :ui do
  include_context 'ApplicationController'

  before do
    allow(License).to receive_message_chain(:get, :supports_vuln_validation?).and_return(true)
    skip_required_checks_on(controller)
    skip_admin_check_on(controller)
    stub_workspace_with(workspace)
    allow(controller).to receive_messages(:current_user => user)
  end

  it_behaves_like 'filter values endpoint' do
    let(:controller_action) { :filter_values}
    let(:facet_keys) do
      [
        'address',
        'name',
        'os_name'
      ]
    end
    let(:host) { FactoryBot.create(:mdm_host, workspace: workspace) }
    let(:vuln) { FactoryBot.create(:mdm_vuln, host: host) }

    let(:opts) do
      {
          workspace_id: workspace.id,
      }
    end
  end

end
