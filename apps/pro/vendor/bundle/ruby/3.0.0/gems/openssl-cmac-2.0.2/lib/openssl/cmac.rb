require 'openssl'

module OpenSSL
  # CMACError used for wrong parameter resonse.
  class CMACError < StandardError
  end

  # Abstract from http://tools.ietf.org/html/rfc4493:
  #
  # The National Institute of Standards and Technology (NIST) has
  # recently specified the Cipher-based Message Authentication Code
  # (CMAC), which is equivalent to the One-Key CBC MAC1 (OMAC1) submitted
  # by Iwata and Kurosawa.  This memo specifies an authentication
  # algorithm based on CMAC with the 128-bit Advanced Encryption Standard
  # (AES).  This new authentication algorithm is named AES-CMAC.  The
  # purpose of this document is to make the AES-CMAC algorithm
  # conveniently available to the Internet Community.
  #
  # http://tools.ietf.org/html/rfc4494
  # reduces the length of the result from 16 to 12 Byte.
  #
  # http://tools.ietf.org/html/rfc4615
  # allows to use variable key sizes.
  class CMAC
    # Searches for supported algorithms within OpenSSL
    #
    # @return [[String]] supported algorithms
    def self.ciphers
      @ciphers ||= OpenSSL::Cipher.ciphers.select { |c| c.match(/-128-CBC$/i) }.map { |e| e[0..-9].upcase }.uniq
    end

    # Returns the authentication code as a binary string. The cipher parameter
    # must be an entry of OpenSSL::CMAC.ciphers.
    #
    # @param cipher [String] entry of OpenSSL::CMAC.ciphers
    # @param key [String] binary key string
    # @param data [String] binary data string
    # @param length [Number] length of the authentication code
    #
    # @return [String] authentication code
    def self.digest(cipher, key, data, length = 16)
      CMAC.new(cipher, key).update(data).digest(length)
    end

    public

    # Returns an instance of OpenSSL::CMAC set with the cipher algorithm and
    # key to be used. The instance represents the initial state of the message
    # authentication code before any data has been processed. To process data
    # with it, use the instance method update with your data as an argument.
    #
    # @param cipher [String] entry of OpenSSL::CMAC.ciphers
    # @param key [String] binary key string
    #
    # @return [Object] the new CMAC object
    def initialize(cipher, key = '')
      unless CMAC.ciphers.include?(cipher.upcase)
        fail CMACError, "unsupported cipher algorithm (#{cipher})"
      end

      @keys = []
      @buffer = ''.force_encoding('ASCII-8BIT')
      @cipher = OpenSSL::Cipher.new("#{cipher.upcase}-128-CBC")

      self.key = key unless key == ''
    end

    # Returns self as it was when it was first initialized with new key,
    # with all processed data cleared from it.
    #
    # @param key [String] binary key string
    #
    # @return [Object] self with initial state and new key
    def key=(key)
      reset
      key = CMAC.digest('AES', "\x00" * 16, key, 16) unless key.b.length == 16

      @keys[0] = key.dup
      @cipher.key = @keys[0]

      cipher = OpenSSL::Cipher.new(@cipher.name)
      cipher.encrypt
      cipher.key = @keys[0]
      k = (cipher.update("\x00" * 16) + cipher.final).bytes[0...16]
      1.upto(2) do |i|
        k = k.pack('C*').unpack('B*')[0]
        msb = k.slice!(0)
        k = [k, '0'].pack('B*').bytes
        k[15] ^= 0x87 if msb == '1'
        @keys[i] = k.dup
      end
      self
    end

    # Alias for: update
    def <<(data)
      update(data)
    end

    # Returns the block length of the used cipher algorithm.
    #
    # @return [Number] length of the used cipher algorithm
    def block_length
      16
    end

    # Returns the maximum length of the resulting digest.
    #
    # @return [Number] maximum length of the resulting digest
    def digest_max_length
      16
    end

    # Returns the name of the used authentication code algorithm.
    #
    # @return [String] name of the used authentication code algorithm
    def name
      "CMAC with #{@cipher.name[0..-9]}"
    end

    # Returns self as it was when it was first initialized,
    # with all processed data cleared from it.
    #
    # @return [Object] self with initial state
    def reset
      @keys.clear
      @buffer.clear
      @cipher.reset unless @keys[0].nil?
      @cipher.iv = "\x00" * 16
      @cipher.encrypt
      self
    end

    # Returns self updated with the message to be authenticated.
    # Can be called repeatedly with chunks of the message.
    #
    # @param data [String] binary data string
    #
    # @return [Object] self with new state
    def update(data)
      fail CMACError, 'no key is set' if @keys[0].nil?

      @buffer += data
      @cipher.update(@buffer.slice!(0...16)) while @buffer.length > 16
      self
    end

    # Returns the authentication code an instance represents as a binary string.
    #
    # @param length [Number] length of the authentication code
    def digest(length = 16)
      fail CMACError, 'no key is set' if @keys[0].nil?
      fail CMACError, 'no key is set' unless length.between?(1, 16)

      block = @buffer.bytes
      @buffer.clear
      k = @keys[block.length == 16 ? 1 : 2].dup
      i = block.length.times { |t| k[t] ^= block[t] }
      k[i] ^= 0x80 if i < 16
      mac = @cipher.update(k.pack('C*')) + @cipher.final
      @cipher.reset
      @cipher.encrypt
      @cipher.key = @keys[0]
      @cipher.iv = "\x00" * 16
      # Each block is 16-bytes and the last block will always be PKCS#7 padding
      # which we want to discard.  Take the last block prior to the padding for
      # the MAC.
      mac[-32...(-32 + length)]
    end
  end
end
