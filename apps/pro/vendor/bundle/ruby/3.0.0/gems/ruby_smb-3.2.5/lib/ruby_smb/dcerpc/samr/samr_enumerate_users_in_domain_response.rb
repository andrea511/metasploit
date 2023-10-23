module RubySMB
  module Dcerpc
    module Samr

      # [3.1.5.2.5 SamrEnumerateUsersInDomain (Opnum 13)](https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-samr/6bdc92c0-c692-4ffb-9de7-65858b68da75)
      class SamrEnumerateUsersInDomainResponse < BinData::Record
        attr_reader :opnum

        endian :little

        ndr_uint32                :enumeration_context
        psampr_enumeration_buffer :buffer
        ndr_uint32                :count_returned
        ndr_uint32                :error_status

        def initialize_instance
          super
          @opnum = SAMR_ENUMERATE_USERS_IN_DOMAIN
        end
      end

    end
  end
end
