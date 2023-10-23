module Pro
  module DynamicStagers
    module Code
      module AntiDebug
        class CheckRemoteDebuggerPresent < Pro::DynamicStagers::Code::Function

          def initialize
            @name      = "check_remote_debugger_present"
            @type      = "void"
            @arguments = [ ]
            @body      = <<-EOS
          typedef BOOL (__stdcall *CheckRemoteDebuggerPresentProto)(HANDLE,PBOOL);
          typedef HANDLE (__stdcall *GetCurrentProcessProto)(void);

          char cbKernel[] = { CRYPT12('k','e','r','n','e','l','3','2','.','d','l','l'),XOR_KEY };
          char cbCheckRemoteDebuggerPresent[] = { CRYPT26('C','h','e','c','k','R','e','m','o','t','e','D', 'e', 'b', 'u', 'g', 'g', 'e', 'r', 'P', 'r', 'e', 's', 'e', 'n', 't'),XOR_KEY };
          char cbGetCurrentProcess[] = { CRYPT17('G','e','t','C','u','r','r','e','n','t','P','r', 'o', 'c', 'e', 's', 's'),XOR_KEY };

          LIBLOAD(hKernel, cbKernel);

          RDLLOAD(GetCurrentProcessRDL, GetCurrentProcessProto, hKernel, cbGetCurrentProcess);
          RDLLOAD(CheckRemoteDebuggerPresentRDL, CheckRemoteDebuggerPresentProto, hKernel, cbCheckRemoteDebuggerPresent);

          BOOL remotedbg;

          CheckRemoteDebuggerPresentRDL(GetCurrentProcessRDL(), &remotedbg );

          if (remotedbg){
            exit(0);
          }
            EOS
          end
        end
      end
    end
  end
end
