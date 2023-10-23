module Pro
  module DynamicStagers
    module Code
      module AntiDebug
        class IsHookPresent < Pro::DynamicStagers::Code::Function

          def initialize
            @name      = "is_hook_present"
            @type      = "void"
            @arguments = [ ]
            @body      = <<-EOS
          char cbKernel[] = { CRYPT12('k','e','r','n','e','l','3','2','.','d','l','l'),XOR_KEY };
          LIBLOAD(hKernel, cbKernel);

          typedef BOOL (__stdcall *CreateProcessAProto)(LPCSTR, LPSTR, LPSECURITY_ATTRIBUTES, LPSECURITY_ATTRIBUTES, BOOL, DWORD, LPVOID, LPCSTR, LPSTARTUPINFO, LPPROCESS_INFORMATION);
          char cbCreateProcessA[] = { CRYPT14('C','r','e','a','t','e','P','r','o','c','e','s','s','A'),XOR_KEY };
          RDLLOAD(CreateProcessARDL, CreateProcessAProto, hKernel, cbCreateProcessA);

          typedef BOOL (__stdcall *ReadProcessMemoryProto)(HANDLE, LPCVOID, LPVOID, size_t, size_t);
          char cbReadProcessMemory[] = { CRYPT17('R', 'e', 'a', 'd', 'P', 'r', 'o', 'c', 'e', 's', 's', 'M', 'e', 'm', 'o', 'r', 'y'),XOR_KEY };
          RDLLOAD(ReadProcessMemoryRDL, ReadProcessMemoryProto, hKernel, cbReadProcessMemory);

          typedef HANDLE (__stdcall *GetCurrentProcessProto)(VOID);
          char cbGetCurrentProcess[] = { CRYPT17('G', 'e', 't', 'C', 'u', 'r', 'r', 'e', 'n', 't', 'P', 'r', 'o', 'c', 'e', 's', 's'),XOR_KEY };
          RDLLOAD(GetCurrentProcessRDL, GetCurrentProcessProto, hKernel, cbGetCurrentProcess);


          // Check for jump on void createprocess call from current process
          unsigned char bBuffer;
          ReadProcessMemoryRDL( GetCurrentProcessRDL(), (LPVOID *) CreateProcessARDL, &bBuffer, 1, 0 );
          // If the first byte of CreateProcessA is equal to 0xE9 (JMP), then it is hooking
          if( bBuffer == 0xE9 ){
            exit(0);
          }
            EOS
          end

        end
      end
    end
  end
end

