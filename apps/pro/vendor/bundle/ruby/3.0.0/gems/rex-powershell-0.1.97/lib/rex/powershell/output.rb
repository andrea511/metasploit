# -*- coding: binary -*-

require 'zlib'
require 'rex/text'

module Rex
module Powershell
  module Output
    #
    # To String
    #
    # @return [String] Code
    def to_s
      code
    end

    #
    # Returns code size
    #
    # @return [Integer] Code size
    def size
      code.size
    end

    #
    # Return code with numbered lines
    #
    # @return [String] Powershell code with line numbers
    def to_s_lineno
      numbered = ''
      code.split(/\r\n|\n/).each_with_index do |line, idx|
        numbered << "#{idx}: #{line}"
      end

      numbered
    end

    #
    # Return a zlib compressed powershell code wrapped in decode stub
    #
    # @param eof [String] End of file identifier to append to code
    #
    # @return [String] Zlib compressed powershell code wrapped in
    # decompression stub
    def deflate_code(eof = nil)
      # Compress using the Deflate algorithm
      compressed_stream = ::Zlib::Deflate.deflate(code,
                                                  ::Zlib::BEST_COMPRESSION)

      # Base64 encode the compressed file contents
      encoded_stream = Rex::Text.encode_base64(compressed_stream)


      # Build the powershell expression
      # Decode base64 encoded command and create a stream object
      psh_expression =  "$s=New-Object System.IO.MemoryStream(,"
      psh_expression << "[System.Convert]::FromBase64String(#{Obfu.scate_string_literal(encoded_stream, threshold: 0.01)}));"
      # Read & delete the first two bytes due to incompatibility with MS
      psh_expression << '$s.ReadByte();'
      psh_expression << '$s.ReadByte();'
      # Uncompress and invoke the expression (execute)
      psh_expression << 'IEX (New-Object System.IO.StreamReader('
      psh_expression << 'New-Object System.IO.Compression.DeflateStream('
      psh_expression << '$s,'
      psh_expression << '[System.IO.Compression.CompressionMode]::Decompress)'
      psh_expression << ')).ReadToEnd();'

      # If eof is set, add a marker to signify end of code output
      # if (eof && eof.length == 8) then psh_expression += "'#{eof}'" end
      psh_expression << "echo '#{eof}';" if eof

      @code = psh_expression
    end

    #
    # Return Base64 encoded powershell code
    #
    # @return [String] Base64 encoded powershell code
    def encode_code(eof = nil)
      @code = Rex::Text.encode_base64(Rex::Text.to_unicode(code))
    end

    #
    # Return ASCII powershell code from base64/unicode
    #
    # @return [String] ASCII powershell code
    def decode_code
      @code = Rex::Text.to_ascii(Rex::Text.decode_base64(code))
    end

    #
    # Return a gzip compressed powershell code wrapped in decoder stub
    #
    # @param eof [String] End of file identifier to append to code
    #
    # @return [String] Gzip compressed powershell code wrapped in
    # decompression stub
    def gzip_code(eof = nil)
      # Compress using the Gzip algorithm
      compressed_stream = Rex::Text.gzip(code)

      # Base64 encode the compressed file contents
      encoded_stream = Rex::Text.encode_base64(compressed_stream)

      # Build the powershell expression
      # Create and execute script lock fed by the IO.StreamReader
      psh_expression = '&([scriptblock]::create((New-Object System.IO.StreamReader('
      # Feed StreamREader from a GzipStream
      psh_expression << 'New-Object System.IO.Compression.GzipStream('
      # GzipStream operates on the Memory Stream
      psh_expression << '(New-Object System.IO.MemoryStream(,'
      # MemoryStream consists of base64 encoded compressed data
      psh_expression << "[System.Convert]::FromBase64String(#{Obfu.scate_string_literal(encoded_stream, threshold: 0.01)})))"
      # Set the GzipStream to decompress its MemoryStream contents
      psh_expression << ',[System.IO.Compression.CompressionMode]::Decompress)'
      # Read the decoded, decompressed result into scriptblock contents
      psh_expression << ')).ReadToEnd()))'

      # If eof is set, add a marker to signify end of code output
      # if (eof && eof.length == 8) then psh_expression += "'#{eof}'" end
      psh_expression << "echo '#{eof}';" if eof

      @code = psh_expression
    end

    #
    # Compresses script contents with gzip (default) or deflate
    #
    # @param eof [String] End of file identifier to append to code
    # @param gzip [Boolean] Whether to use gzip compression or deflate
    #
    # @return [String] Compressed code wrapped in decompression stub
    def compress_code(eof = nil, gzip = true)
      @code = gzip ? gzip_code(eof) : deflate_code(eof)
    end

    #
    # Reverse the compression process
    # Try gzip, inflate if that fails
    #
    # @return [String] Decompressed powershell code
    def decompress_code
      # Extract substring with payload4
      if @code =~ /FromBase64String\('([a-zA-z0-9\+\/=]*)'\)/
        encoded_stream = Regexp.last_match(1)
      elsif @code =~ /FromBase64String(\((?>[^)(]+|\g<1>)*\))/
        encoded_stream = Obfu.descate_string_literal(Regexp.last_match(1))
      else
        raise Exceptions::PowershellError, 'Failed to identify the base64 data'
      end

      # Decode and decompress the string
      unencoded = Rex::Text.decode_base64(encoded_stream)
      begin
        @code = Rex::Text.ungzip(unencoded) || Rex::Text.zlib_inflate(unencoded)
      rescue Zlib::GzipFile::Error
        begin
          @code = Rex::Text.zlib_inflate(unencoded)
        rescue Zlib::DataError => e
          raise Exceptions::PowershellError, 'Invalid compression'
        end
      end

      @code
    end
  end
end
end
