RSpec.describe RubySMB::Dcerpc::Samr::SamrEnumerateUsersInDomainResponse do
  subject(:packet) { described_class.new }

  it { is_expected.to respond_to :enumeration_context }
  it { is_expected.to respond_to :buffer }
  it { is_expected.to respond_to :count_returned }
  it { is_expected.to respond_to :error_status }
  it { is_expected.to respond_to :opnum }

  it 'is little endian' do
    expect(described_class.fields.instance_variable_get(:@hints)[:endian]).to eq :little
  end
  it 'is a BinData::Record' do
    expect(packet).to be_a(BinData::Record)
  end
  describe '#enumeration_context' do
    it 'is a NdrUint32 structure' do
      expect(packet.enumeration_context).to be_a RubySMB::Dcerpc::Ndr::NdrUint32
    end
  end
  describe '#buffer' do
    it 'is a PsamprEnumerationBuffer structure' do
      expect(packet.buffer).to be_a RubySMB::Dcerpc::Samr::PsamprEnumerationBuffer
    end
  end
  describe '#count_returned' do
    it 'is a NdrUint32 structure' do
      expect(packet.count_returned).to be_a RubySMB::Dcerpc::Ndr::NdrUint32
    end
  end
  describe '#error_status' do
    it 'is a NdrUint32 structure' do
      expect(packet.error_status).to be_a RubySMB::Dcerpc::Ndr::NdrUint32
    end
  end
  describe '#initialize_instance' do
    it 'sets #opnum to SAMR_ENUMERATE_USERS_IN_DOMAIN constant' do
      expect(packet.opnum).to eq(RubySMB::Dcerpc::Samr::SAMR_ENUMERATE_USERS_IN_DOMAIN)
    end
  end
  it 'reads itself' do
    new_packet = described_class.new(
      enumeration_context: 0,
      buffer: {
        entries_read: 3,
        buffer: [
          { relative_id: 500, name: "Administrator" },
          { relative_id: 501, name: "Guest" },
          { relative_id: 1001, name: "WIN-DP0M1BC768$" }
        ]
      },
      count_returned: 3,
      error_status: 0
    )
    expected_output = {
      enumeration_context: 0,
      buffer: {
        entries_read: 3,
        buffer: [
          {relative_id: 500, name: { buffer_length: 26, maximum_length: 26, buffer: "Administrator".encode('utf-16le') }},
          {relative_id: 501, name: { buffer_length: 10, maximum_length: 10, buffer: "Guest".encode('utf-16le') }},
          {relative_id: 1001, name: { buffer_length: 30, maximum_length: 30, buffer: "WIN-DP0M1BC768$".encode('utf-16le') }}
        ]
      },
      count_returned: 3,
      error_status: 0
    }
    expect(packet.read(new_packet.to_binary_s)).to eq(expected_output)
  end
end
