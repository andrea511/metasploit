RSpec.describe RubySMB::SMB1::Packet::Trans2::QueryFileInformationResponse do
  subject(:packet) { described_class.new }

  describe '#smb_header' do
    subject(:header) { packet.smb_header }

    it 'is a standard SMB Header' do
      expect(header).to be_a RubySMB::SMB1::SMBHeader
    end

    it 'should have the command set to SMB_COM_TRANSACTION2' do
      expect(header.command).to eq RubySMB::SMB1::Commands::SMB_COM_TRANSACTION2
    end

    it 'should have the response flag set' do
      expect(header.flags.reply).to eq 1
    end
  end

  describe '#parameter_block' do
    subject(:parameter_block) { packet.parameter_block }

    it 'should have the setup set to the QUERY_FILE_INFORMATION subcommand' do
      expect(parameter_block.setup).to include RubySMB::SMB1::Packet::Trans2::Subcommands::QUERY_FILE_INFORMATION
    end
  end

  describe '#data_block' do
    subject(:data_block) { packet.data_block }

    it 'is a standard DataBlock' do
      expect(data_block).to be_a RubySMB::SMB1::DataBlock
    end

    it { is_expected.to respond_to :name }
    it { is_expected.to respond_to :trans2_parameters }
    it { is_expected.to respond_to :trans2_data }

    it 'should keep #trans2_parameters 4-byte aligned' do
      expect(data_block.trans2_parameters.abs_offset % 4).to eq 0
    end

    describe '#trans2_parameters' do
      subject(:parameters) { data_block.trans2_parameters }

      it { is_expected.to respond_to :ea_error_offset }

      describe '#ea_error_offset' do
        it 'is a 16-bit field' do
          expect(parameters.ea_error_offset).to be_a BinData::Uint16le
        end
      end
    end

    describe '#trans2_data' do
      subject(:data) { data_block.trans2_data }

      it { is_expected.to respond_to :buffer }

      describe '#buffer' do
        it 'is a String field' do
          expect(data.buffer).to be_a BinData::String
        end
      end

      context 'when the buffer is empty' do
        before :each do
          data.buffer = ''
        end

        it 'should not be padded' do
          expect(data_block.pad2.num_bytes).to eq 0
        end

        it 'should read its own binary representation' do
          expect(packet.class.read(packet.to_binary_s).data_block.trans2_data.buffer).to eq ''
        end
      end

      context 'when the buffer is not empty' do
        before :each do
          data.buffer = 'test'
        end

        it 'should be padded to a 4-byte boundary' do
          expect(data_block.trans2_data.abs_offset % 4).to eq 0
        end

        it 'should read its own binary representation' do
          expect(packet.class.read(packet.to_binary_s).data_block.trans2_data.buffer).to eq 'test'
        end
      end
    end
  end

end
