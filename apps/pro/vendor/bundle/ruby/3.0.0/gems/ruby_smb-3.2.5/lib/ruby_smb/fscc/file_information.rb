module RubySMB
  module Fscc
    # Namespace and constant values for File Information Classes, as defined in
    # [2.4 File Information Classes](https://msdn.microsoft.com/en-us/library/cc232064.aspx)
    module FileInformation
      # Information class used in directory enumeration to return detailed
      # information about the contents of a directory.
      FILE_DIRECTORY_INFORMATION         = 0x01

      # Information class used in directory enumeration to return detailed
      # information (with extended attributes size) about the contents of a
      # directory.
      FILE_FULL_DIRECTORY_INFORMATION    = 0x02

      # Information class used in directory enumeration to return detailed
      # information (with extended attributes size and short names) about the
      # contents of a directory.
      FILE_BOTH_DIRECTORY_INFORMATION    = 0x03

      # Information class used to query or set file information.
      FILE_BASIC_INFORMATION             = 0x04

      # Information class is used to query file information.
      FILE_STANDARD_INFORMATION          = 0x05

      # Information class used to query for the file system's 64-bit file ID.
      FILE_INTERNAL_INFORMATION          = 0x06

      # Information class used to query for the size of the extended attributes
      # (EA) for a file.
      FILE_EA_INFORMATION                = 0x07

      # Information class used to query the access rights of a file that were
      # granted when the file was opened.
      FILE_ACCESS_INFORMATION            = 0x08

      # Information class is used locally to query the name of a file.
      FILE_NAME_INFORMATION              = 0x09

      # Information class used to rename a file.
      FILE_RENAME_INFORMATION            = 0x0A

      # Information class used in directory enumeration to return detailed
      # information (with only filenames) about the contents of a directory.
      FILE_NAMES_INFORMATION             = 0x0C

      # Information class used to mark a file for deletion.
      FILE_DISPOSITION_INFORMATION       = 0x0D

      # Information class used to query or set the position of the file pointer
      # within a file.
      FILE_POSITION_INFORMATION          = 0x0E

      # Information class used to query or set the mode of the file.
      FILE_MODE_INFORMATION              = 0x10

      # Information class used to query the buffer alignment required by the
      # underlying device.
      FILE_ALIGNMENT_INFORMATION         = 0x11

      # Information class used to enumerate the data streams of a file or a
      # directory.
      FILE_STREAM_INFORMATION            = 0x16

      # This information class is used to query for information that is commonly
      # needed when a file is opened across a network.
      FILE_NETWORK_OPEN_INFORMATION      = 0x22

      # Information class used in directory enumeration to return detailed
      # information (with extended attributes size, short names and file ID)
      # about the contents of a directory.
      FILE_ID_BOTH_DIRECTORY_INFORMATION = 0x25

      # Information class used in directory enumeration to return detailed
      # information (with extended attributes size and file ID) about the
      # contents of a directory.
      FILE_ID_FULL_DIRECTORY_INFORMATION = 0x26


      # This information class is used to query the normalized name of a file. A
      # normalized name is an absolute pathname where each short name component
      # has been replaced with the corresponding long name component, and each
      # name component uses the exact letter casing stored on disk.
      FILE_NORMALIZED_NAME_INFORMATION = 0x30


      # Information class is used to query a collection of file information
      # structures.
      FILE_ALL_INFORMATION = 0x12

      # These Information Classes can be used by SMB1 using the pass-through
      # Information Levels when available on the server (CAP_INFOLEVEL_PASSTHRU
      # capability flag in an SMB_COM_NEGOTIATE server response). The constant
      # SMB_INFO_PASSTHROUGH needs to be added to access these Information
      # Levels. This is documented in
      # [2.2.2.3.5 Pass-through Information Level Codes](https://msdn.microsoft.com/en-us/library/ff470158.aspx)
      SMB_INFO_PASSTHROUGH               = 0x03e8

      def self.name(value)
        constants.select { |c| c.upcase == c }.find { |c| const_get(c) == value }
      end

      require 'ruby_smb/fscc/file_information/file_directory_information'
      require 'ruby_smb/fscc/file_information/file_full_directory_information'
      require 'ruby_smb/fscc/file_information/file_disposition_information'
      require 'ruby_smb/fscc/file_information/file_id_full_directory_information'
      require 'ruby_smb/fscc/file_information/file_both_directory_information'
      require 'ruby_smb/fscc/file_information/file_id_both_directory_information'
      require 'ruby_smb/fscc/file_information/file_name_information'
      require 'ruby_smb/fscc/file_information/file_names_information'
      require 'ruby_smb/fscc/file_information/file_normalized_name_information'
      require 'ruby_smb/fscc/file_information/file_rename_information'
      require 'ruby_smb/fscc/file_information/file_network_open_information'
      require 'ruby_smb/fscc/file_information/file_ea_information'
      require 'ruby_smb/fscc/file_information/file_stream_information'
      require 'ruby_smb/fscc/file_information/file_basic_information'
      require 'ruby_smb/fscc/file_information/file_standard_information'
      require 'ruby_smb/fscc/file_information/file_internal_information'
      require 'ruby_smb/fscc/file_information/file_access_information'
      require 'ruby_smb/fscc/file_information/file_position_information'
      require 'ruby_smb/fscc/file_information/file_mode_information'
      require 'ruby_smb/fscc/file_information/file_alignment_information'
      require 'ruby_smb/fscc/file_information/file_all_information'
    end
  end
end
