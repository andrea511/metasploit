require 'spec_helper'

RSpec.describe Apps::FirewallEgress::Scan, :engine, :ui do
  let(:dst_host){ '10.6.2.99' }
  subject(:scan){ described_class.new(:dst_host => dst_host)}

  describe '.valid_dst_host?' do
    context 'when the hostname can be resolved' do
      it 'returns true' do
        allow(Rex::Socket).to receive(:addr_atoi)

        expect(scan.valid_dst_host?).to be true
      end
    end

    context 'when the hostname cannot be resolved' do
      it 'returns false' do
        allow(Rex::Socket).to receive(:addr_atoi).and_raise(Resolv::ResolvError)

        expect(scan.valid_dst_host?).to be false
      end
    end

  end

  describe '.valid_port_range?' do
    it 'should have a Integer start' do
      expect(described_class.valid_port_range?(3.14, 3000)).to be false
    end

    it 'should have a Integer stop' do
      expect(described_class.valid_port_range?(3000, 3.14)).to be false
    end

    it 'should have a positive start' do
      expect(described_class.valid_port_range?(-3000, 3014)).to be false
    end

    it 'should have a positive stop' do
      expect(described_class.valid_port_range?(3000, -3014)).to be false
    end

    it 'should have a start and stop in the valid TCP range' do
      expect(described_class.valid_port_range?(1233000, 1233014)).to be false
    end

    it 'should have a stop greater than start' do
      expect(described_class.valid_port_range?(1230, 1204)).to be false
    end

    it 'should allow the entire valid TCP range' do
      expect(described_class.valid_port_range?(1, Apps::FirewallEgress::TaskConfig::MAX_PORT)).to be true
    end
  end


  describe "associated RunStat objects" do
    before(:example) do
      allow(scan).to receive(:task_id).and_return 5
    end

    it 'should have an #open_port_count' do
      expect(scan).to respond_to :open_port_count
    end

    it 'should have an #open_port_count=' do
      expect(scan).to respond_to :open_port_count=
    end

    it 'should have a RunStat object set in #open_port_count' do
      expect(scan.open_port_count).to be_instance_of ::RunStat
    end

    it 'should have a default value of 0 for open_port_count' do
      expect(scan.open_port_count.data).to eq(0)
    end

    it 'should have a task_id field matching the scan\'s' do
      expect(scan.open_port_count.task_id).to eq(5)
    end

    it 'should have an #closed_port_count' do
      expect(scan).to respond_to :closed_port_count
    end

    it 'should have an #closed_port_count=' do
      expect(scan).to respond_to :closed_port_count=
    end

    it 'should have a RunStat object set in #closed_port_count' do
      expect(scan.closed_port_count).to be_instance_of ::RunStat
    end

    it 'should have a default value of 0 for closed_port_count' do
      expect(scan.closed_port_count.data).to eq(0)
    end

    it 'should have a task_id field matching the scan\'s' do
      expect(scan.closed_port_count.task_id).to eq(5)
    end

    it 'should have an #filtered_port_count' do
      expect(scan).to respond_to :filtered_port_count
    end

    it 'should have an #filtered_port_count=' do
      expect(scan).to respond_to :filtered_port_count=
    end

    it 'should have a RunStat object set in #filtered_port_count' do
      expect(scan.filtered_port_count).to be_instance_of ::RunStat
    end

    it 'should have a default value of 0 for filtered_port_count' do
      expect(scan.filtered_port_count.data).to eq(0)
    end

    it 'should have a task_id field matching the scan\'s' do
      expect(scan.filtered_port_count.task_id).to eq(5)
    end

  end

  describe "#parsed_ports" do
    let(:port_set) do
      [
          [1, "open"],
          [2, "open"],
          [3, "open"],
          [4, "closed"],
          [5, "closed"],
          [6, "closed"],
          [7, "filtered"],
          [8, "filtered"]
      ]
    end
    describe "port info for stats" do
      describe "#parsed_ports_by_state" do
        before(:example) do
          allow(scan).to receive(:parsed_ports).and_return port_set
        end

        describe ":open" do
          it 'should return just the ports that are open' do
            expect(scan.parsed_ports_by_state(:open)).to match_array([[1, 'open'], [2, 'open'], [3,'open']])
          end
        end

        describe ":closed" do
          it 'should return just the ports that are closed' do
            expect(scan.parsed_ports_by_state(:closed)).to match_array([[4, 'closed'], [5, 'closed'], [6,'closed']])
          end
        end

        describe ":filtered" do
          it 'should return just the ports that are filtered' do
            expect(scan.parsed_ports_by_state(:filtered)).to match_array([[7,'filtered'], [8, 'filtered']])
          end
        end

      end
    end
  end

  describe "nmap command" do
    describe "port ranges" do
      context "when the scan has been initialized with a set of ports" do
        before(:example) do
          allow(scan).to receive(:nmap_start_port).and_return 22
          allow(scan).to receive(:nmap_stop_port).and_return 2500
        end

        it 'should format the ports into a range suitable for nmap' do
          expect(scan.nmap_port_arg).to eq("-p22-2500")
        end

        it 'should have a full command which contains a properly formed port argument' do
          expect(scan.nmap_command.join(" ")).to match(/\-p[0-9]+\-[0-9]+/)
        end

      end

      context "when the scan has NOT been initialized with a set of ports" do
        before(:example) do
          allow(scan).to receive(:nmap_start_port).and_return nil
          allow(scan).to receive(:nmap_stop_port).and_return nil
        end

        it 'should return empty string' do
          expect(scan.nmap_port_arg).to eq('')
        end

        it 'should not have the empty string in the final nmap command' do
          expect(scan.nmap_command).not_to include("")
        end
      end
    end
  end


  describe "#build_result_range" do
    before(:example) do
      @result_range = scan.build_result_range(:start_port => 1234, :end_port => 1237, :target_host => dst_host, :state => "filtered")
    end

    it 'should build an Apps::FirewallEgress::ResultRange object' do
      expect(@result_range).to be_instance_of Apps::FirewallEgress::ResultRange
    end
    it 'should give a valid object' do
      expect(@result_range).to be_valid
    end
  end

  describe "parsing runs of ports" do
    context "when the last one is the same as the one before it" do
      let(:last_same) do
        [
            [1, "open"],
            [2, "open"],
            [3, "open"],
            [4, "closed"],
            [5, "closed"],
            [6, "closed"],
        ]
      end

      before(:example) do
        allow(scan).to receive(:parsed_ports).and_return last_same
        scan.build_all_result_ranges
      end

      it 'should create a ResultRange object for each run of consecutive ports in the same state' do
        expect(scan.result_ranges.size).to eq(2)
      end

      it 'should have the proper start port, stop port, and state' do
        expect(scan.result_ranges.select{|r| r.start_port == 1 and r.end_port == 3 and r.state =="open"}).to be_present
        expect(scan.result_ranges.select{|r| r.start_port == 4 and r.end_port == 6 and r.state =="closed"}).to be_present
      end
    end

    context "when the last one is different than the one immediately preceding it" do
      let(:last_different) do
        [
            [1, "open"],
            [2, "open"],
            [3, "open"],
            [4, "closed"],
            [5, "closed"],
            [6, "open"],
        ]
      end

      before(:example) do
        allow(scan).to receive(:parsed_ports).and_return last_different
        scan.build_all_result_ranges
      end

      it 'should create a ResultRange object for each run of consecutive ports in the same state' do
        expect(scan.result_ranges.size).to eq(3)
      end

      it 'should have the proper start port, stop port, and state' do
        expect(scan.result_ranges.select{|r| r.start_port == 1 and r.end_port == 3 and r.state =="open"}).to be_present
        expect(scan.result_ranges.select{|r| r.start_port == 4 and r.end_port == 5 and r.state =="closed"}).to be_present
        expect(scan.result_ranges.select{|r| r.start_port == 6 and r.end_port == 6 and r.state =="open"}).to be_present
      end
    end

    context "when there is a gap in the ports" do
      let(:non_sequential_port_set) do
        [
            [1, "open"],
            [2, "open"],
            [3, "open"],
            [4, "closed"],
            [5, "closed"],
            [6, "closed"],
            [70, "filtered"],
            [80, "filtered"]
        ]
      end

      before(:example) do
        allow(scan).to receive(:parsed_ports).and_return non_sequential_port_set
        scan.build_all_result_ranges
      end

      it 'should create the proper number of ResultRanges' do
        expect(scan.result_ranges.size).to eq(4)
      end

      it 'should have the proper start port, stop port, and state' do
        expect(scan.result_ranges.select{|r| r.start_port == 1 and r.end_port == 3 and r.state =="open"}).to be_present
        expect(scan.result_ranges.select{|r| r.start_port == 4 and r.end_port == 6 and r.state =="closed"}).to be_present
        expect(scan.result_ranges.select{|r| r.start_port == 70 and r.end_port == 70 and r.state =="filtered"}).to be_present
        expect(scan.result_ranges.select{|r| r.start_port == 80 and r.end_port == 80 and r.state =="filtered"}).to be_present
      end

    end

  end

end
