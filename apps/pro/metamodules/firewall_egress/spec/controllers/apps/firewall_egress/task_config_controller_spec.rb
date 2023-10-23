require 'spec_helper'

RSpec.describe Apps::FirewallEgress::TaskConfigController, :ui do
  include_context 'MetaModule FormController'

  let(:port_type) { :default_nmap_port_set }
  let(:start_port) { 1 }
  let(:stop_port) { 1024 }
  let(:form_params) do
    {
        :task_config => {
            :nmap_start_port => start_port,
            :nmap_stop_port => stop_port,
            :port_type => port_type
        }
    }
  end

  context 'requesting the form' do
    it_should_behave_like 'metamodule rendering a form', {
      :steps => described_class::STEPS
    }
  end

  context 'submitting validation requests' do
    context 'from the Configure Scan tab' do
      let(:step) { described_class::STEPS[0] }

      context 'when using the default nmap port set' do
        let(:port_type) { :default_nmap_port_set }
        it_should_behave_like "metamodule responding with a validation success"
      end

      context 'when using a custom port range' do
        let(:port_type) { :custom_range }
        let(:start_port) { '' }
        let(:stop_port) { '' }


        context 'with a blank port range' do
          let(:start_port) { '' }
          let(:stop_port) { '' }
          it_should_behave_like "metamodule responding with a validation error"
        end

        context 'with a port range from 0 to 0' do
          let(:start_port) { '0' }
          let(:stop_port) { '0' }
          it_should_behave_like "metamodule responding with a validation error"
        end

        context 'with a port range from -1 to -2' do
          let(:start_port) { '-1' }
          let(:stop_port) { '-2' }
          it_should_behave_like "metamodule responding with a validation error"
        end

        context 'with a port range from A to Z' do
          let(:start_port) { 'A' }
          let(:stop_port) { 'Z' }
          it_should_behave_like "metamodule responding with a validation error"
        end

        context 'with a port range from 0 to 100000' do
          let(:start_port) { '0' }
          let(:stop_port) { '100000' }
          it_should_behave_like "metamodule responding with a validation error"
        end

        context 'with a valid port range from 1 to 1024' do
          let(:start_port) { '1' }
          let(:stop_port) { '1024' }
          it_should_behave_like "metamodule responding with a validation success"
        end
      end
    end

    it_should_behave_like 'metamodule validating the Generate Report tab'
  end

  context 'launching the metamodule' do
    context 'with valid params' do
      it_should_behave_like 'metamodule launching successfully'
    end

    context 'with invalid params' do
      let(:port_type) { :custom_range }
      let(:start_port) { 'a' }

      it_should_behave_like 'metamodule fails to launch'
    end
  end
end