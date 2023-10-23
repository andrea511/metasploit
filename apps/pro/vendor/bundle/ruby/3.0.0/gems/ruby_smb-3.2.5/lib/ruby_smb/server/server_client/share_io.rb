module RubySMB
  class Server
    class ServerClient
      module ShareIO
        def proxy_share_io_smb1(request, session)
          share_processor = session.tree_connect_table[request.smb_header.tid]
          if share_processor.nil?
            response = SMB1::Packet::EmptyPacket.new
            response.smb_header.nt_status = WindowsError::NTStatus::STATUS_NETWORK_NAME_DELETED
            return response
          end

          logger.debug("Received #{SMB1::Commands.name(request.smb_header.command)} request for share: #{share_processor.provider.name}")
          share_processor.send(__callee__, request)
        end

        alias :do_close_smb1          :proxy_share_io_smb1
        alias :do_nt_create_andx_smb1 :proxy_share_io_smb1
        alias :do_read_andx_smb1      :proxy_share_io_smb1
        alias :do_transactions2_smb1  :proxy_share_io_smb1

        def proxy_share_io_smb2(request, session)
          # see: https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/9a639360-87be-4d49-a1dd-4c6be0c020bd
          share_processor = session.tree_connect_table[request.smb2_header.tree_id]
          if share_processor.nil?
            response = SMB2::Packet::ErrorPacket.new
            response.smb2_header.nt_status = WindowsError::NTStatus::STATUS_NETWORK_NAME_DELETED
            return response
          end

          logger.debug("Received #{SMB2::Commands.name(request.smb2_header.command)} request for share: #{share_processor.provider.name}")
          share_processor.send(__callee__, request)
        end

        alias :do_close_smb2           :proxy_share_io_smb2
        alias :do_create_smb2          :proxy_share_io_smb2
        alias :do_ioctl_smb2           :proxy_share_io_smb2
        alias :do_query_directory_smb2 :proxy_share_io_smb2
        alias :do_query_info_smb2      :proxy_share_io_smb2
        alias :do_read_smb2            :proxy_share_io_smb2

      end
    end
  end
end
