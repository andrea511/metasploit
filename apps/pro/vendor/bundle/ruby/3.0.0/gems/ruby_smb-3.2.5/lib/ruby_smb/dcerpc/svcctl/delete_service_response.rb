module RubySMB
  module Dcerpc
    module Svcctl

      # [3.1.4.2 RDeleteService (Opnum 2)](https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-scmr/6744cdb8-f162-4be0-bb31-98996b6495be)
      class DeleteServiceResponse < BinData::Record
        attr_reader :opnum

        endian :little

        ndr_uint32                :error_status

        def initialize_instance
          super
          @opnum = DELETE_SERVICE
        end
      end

    end
  end
end
