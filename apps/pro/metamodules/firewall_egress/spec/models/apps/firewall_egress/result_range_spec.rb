require 'spec_helper'
require 'apps/firewall_egress/result_range'

RSpec.describe Apps::FirewallEgress::ResultRange, :engine, :ui do
  subject(:result_range) {FactoryBot.build(:firewall_egress_result_range)}

  describe "validity" do
    describe "factory fixture" do
      it {is_expected.to be_valid}
    end

    describe "for target host" do
      it 'should not be empty' do
        result_range.target_host = nil
        expect(result_range).to validate_presence_of(:target_host)
      end
    end

    describe "for port state" do
      it { is_expected.to validate_inclusion_of(:state).in_array described_class::VALID_PORT_STATES}
    end

    describe "for port bounds" do
      [:start_port, :end_port].each do |port_range_bound|
        it "should not allow negative port numbers for #{port_range_bound}" do
          result_range.send("#{port_range_bound}=", -1)
          expect(result_range).not_to be_valid
        end

        it "should not allow floats for #{port_range_bound}" do
          result_range.send("#{port_range_bound}=", 3.1415)
          expect(result_range).not_to be_valid
        end

        it "should not allow numbers bigger than 65535 for #{port_range_bound}" do
          result_range.send("#{port_range_bound}=", 70000)
          expect(result_range).not_to be_valid
        end
      end

    end

  end

end
