module Pro
  module DynamicStagers
    module Code
      module AntiDebug
        class NtQueryInformationProcess < Pro::DynamicStagers::Code::Function

          def initialize
            @name      = "nt_query_information_process"
            @type      = "void"
            @arguments = []
            @body      = <<-EOS
          char cbKernel[] = { CRYPT12('k','e','r','n','e','l','3','2','.','d','l','l'),XOR_KEY };
          LIBLOAD(hKernel, cbKernel);

          // begin NtQueryInformationProcess
          char cbNtdll[] = { CRYPT9('n', 't', 'd', 'l', 'l', '.', 'd', 'l', 'l'), XOR_KEY };
          LIBLOAD(hNtdll, cbNtdll);

          char cbNtQueryInformationProcess[] = { CRYPT25('N', 't', 'Q', 'u', 'e', 'r', 'y', 'I', 'n', 'f', 'o', 'r', 'm', 'a', 't', 'i', 'o', 'n', 'P', 'r', 'o', 'c', 'e', 's', 's'), XOR_KEY };
          char cbGetCurrentThread[] = { CRYPT16('G', 'e', 't', 'C', 'u', 'r', 'r', 'e', 'n', 't', 'T', 'h', 'r', 'e', 'a', 'd'), XOR_KEY };
          char cbNtSetInformationThread[] = { CRYPT22('N', 't', 'S', 'e', 't', 'I', 'n', 'f', 'o', 'r', 'm', 'a', 't', 'i', 'o', 'n', 'T', 'h', 'r', 'e', 'a', 'd'), XOR_KEY };

          typedef VOID(__stdcall *NtQueryInformationProcessProto)(HANDLE, int, LPVOID, ULONG, ULONG_PTR);
          RDLLOAD(NtQueryInformationProcessRDL, NtQueryInformationProcessProto, hNtdll, cbNtQueryInformationProcess);

          typedef HANDLE(__stdcall *GetCurrentThreadProto)(VOID);
          RDLLOAD(GetCurrentThreadRDL, GetCurrentThreadProto, hKernel, cbGetCurrentThread);

          // if any debuggers are still attached, lets just die.
          int debuggerAttached;
          NtQueryInformationProcessRDL((HANDLE )-1, 0x07, (LPVOID *)&debuggerAttached, 4, NULL);

          if (debuggerAttached != 0) {
            exit(0); // show's over.
          }
            EOS
          end
        end
      end
    end
  end
end
