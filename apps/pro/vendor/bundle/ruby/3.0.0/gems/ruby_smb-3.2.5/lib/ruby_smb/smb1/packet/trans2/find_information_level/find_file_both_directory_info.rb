module RubySMB
  module SMB1
    module Packet
      module Trans2
        module FindInformationLevel
          # The SMB_FIND_FILE_BOTH_DIRECTORY_INFO class as defined in
          # [2.2.8.1.7 SMB_FIND_FILE_BOTH_DIRECTORY_INFO](https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-cifs/2aa849f4-1bc0-42bf-9c8f-d09f11fccc4c)
          class FindFileBothDirectoryInfo < BinData::Record
            CLASS_LEVEL = FindInformationLevel::SMB_FIND_FILE_BOTH_DIRECTORY_INFO

            endian :little

            uint32                  :next_offset,         label: 'Next Entry Offset'
            uint32                  :file_index,          label: 'File Index'
            file_time               :create_time,         label: 'Create Time'
            file_time               :last_access,         label: 'Last Accessed Time'
            file_time               :last_write,          label: 'Last Write Time'
            file_time               :last_change,         label: 'Last Attribute Change Time'
            uint64                  :end_of_file,         label: 'End of File'
            uint64                  :allocation_size,     label: 'Allocated Size'
            smb_ext_file_attributes :ext_file_attributes, label: 'Extended File Attributes'
            uint32                  :file_name_length,    label: 'File Name Length', initial_value: -> { file_name.do_num_bytes }
            uint32                  :ea_size,             label: 'Extended Attributes Size'
            uint8                   :short_name_length,   label: 'Short Name Length'
            uint8                   :reserved,            label: 'Reserved'
            string16                :short_name,          label: 'Short Name', length: 24 # always 12 wchars / 24 bytes

            choice :file_name, :copy_on_change => true, selection: -> { unicode } do
              string16 true,  label: 'File Name', read_length: -> { file_name_length }
              stringz  false, label: 'File Name', read_length: -> { file_name_length }
            end

            # Set unicode encoding for filename
            # @!attribute [rw] unicode
            #   @return [Boolean]
            attr_accessor :unicode

            def initialize_instance
              super
              @unicode = false
            end

          end
        end
      end
    end
  end
end
