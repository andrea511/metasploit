module Pro
  module DynamicStagers
    module Code
      module AntiDebug
        class IsDebuggerPresent < Pro::DynamicStagers::Code::Function

          def initialize
            @name      = "is_debugger_present"
            @type      = "void"
            @arguments = [ ]
            @body      = <<-EOS
          typedef BOOL (__stdcall *IsDebuggerPresentProto)(void);
          char cbKernel[] = { CRYPT12('k','e','r','n','e','l','3','2','.','d','l','l'),XOR_KEY };
          char cbIsDebuggerPresent[] = { CRYPT17('I','s','D','e','b','u','g','g','e','r','P','r', 'e', 's', 'e', 'n', 't'),XOR_KEY };
          LIBLOAD(hKernel, cbKernel);
          RDLLOAD(IsDebuggerPresentRDL, IsDebuggerPresentProto, hKernel, cbIsDebuggerPresent);
          if (IsDebuggerPresentRDL()){
            exit(0);
          }
            EOS
          end

        end
      end
    end
  end
end
