require 'coveralls'
Coveralls.wear!
require 'test/unit'
require 'openssl/cmac'

# Testclass with Test Vectors from RFC's
class CMACTest < Test::Unit::TestCase
  # http://tools.ietf.org/html/rfc4493#section-4
  KEY = ['2b7e151628aed2a6abf7158809cf4f3c'].pack('H*')
  DATA = [[''].pack('H*'),
          ['6bc1bee22e409f96e93d7e117393172a'].pack('H*'),
          ['6bc1bee22e409f96e93d7e117393172a'\
           'ae2d8a571e03ac9c9eb76fac45af8e51'\
           '30c81c46a35ce411'].pack('H*'),
          ['6bc1bee22e409f96e93d7e117393172a'\
           'ae2d8a571e03ac9c9eb76fac45af8e51'\
           '30c81c46a35ce411e5fbc1191a0a52ef'\
           'f69f2445df4f9b17ad2b417be66c3710'].pack('H*')]
  MAC = %w(bb1d6929e95937287fa37d129b756746
           070a16b46b4d4144f79bdd9dd04a287c
           dfa66747de9ae63030ca32611497c827
           51f0bebf7e3b9d92fc49741779363cfe)

  # http://tools.ietf.org/html/rfc4615#section-4
  PRF_KEYS = [['000102030405060708090a0b0c0d0e0fedcb'].pack('H*'),
              ['000102030405060708090a0b0c0d0e0f'].pack('H*'),
              ['00010203040506070809'].pack('H*')]
  PRF_DATA = ['000102030405060708090a0b0c0d0e0f10111213'].pack('H*')
  PRF_OUTS = %w(84a348a4a45d235babfffc0d2b4da09a
                980ae87b5f4c9c5214f5b6a8455e4c2d
                290d9e112edb09ee141fcf64c0b72f3d)

  def test_cmac_keys
    cmac = OpenSSL::CMAC.new('AES')
    cmac.key = KEY
    check_keys(cmac)

    cmac = OpenSSL::CMAC.new('AES', KEY)
    check_keys(cmac)

    assert(cmac.instance_variable_get(:@buffer).empty?, 'Wrong buffer')
    cmac.update(DATA[2])
    assert(cmac.instance_variable_get(:@buffer).length == 8, 'Wrong buffer')
    cmac.update(DATA[2])
    assert(cmac.instance_variable_get(:@buffer).length == 16, 'Wrong buffer')

    cmac.reset
    assert(cmac.instance_variable_get(:@keys)[0].nil?, 'Reset fail')
    assert(cmac.instance_variable_get(:@keys)[1].nil?, 'Reset fail')
    assert(cmac.instance_variable_get(:@keys)[2].nil?, 'Reset fail')
    assert_equal('', cmac.instance_variable_get(:@buffer), 'Reset fail')

    assert_raise(OpenSSL::CMACError) { cmac.update(DATA[2]) }
    assert_raise(OpenSSL::CMACError) { cmac.digest }

    cmac.key = KEY
    check_keys(cmac)

    m = cmac.update(DATA[2]).digest.unpack('H*')[0]
    assert_equal(MAC[2], m)
  end

  def check_keys(cmac)
    assert_equal(
      '2b7e151628aed2a6abf7158809cf4f3c',
      cmac.instance_variable_get(:@keys)[0].unpack('H*')[0],
      'Key ERROR'
    )
    assert_equal(
      'fbeed618357133667c85e08f7236a8de',
      cmac.instance_variable_get(:@keys)[1].pack('C*').unpack('H*')[0],
      'SubKey 1 ERROR'
    )

    assert_equal(
      'f7ddac306ae266ccf90bc11ee46d513b',
      cmac.instance_variable_get(:@keys)[2].pack('C*').unpack('H*')[0],
      'SubKey 2 ERROR'
    )
  end

  def test_cmac_vars
    cmac = OpenSSL::CMAC.new('AES')
    assert_equal(16, cmac.block_length)
    assert_equal(16, cmac.digest_max_length)
    assert_equal('CMAC with AES', cmac.name)
  end

  def test_cmac_update
    for cipher in ['aes', 'AES']
      # Test with 1 call of update and new CCM object for each test.
      DATA.length.times do |i|
        cmac = OpenSSL::CMAC.new(cipher, KEY)
        m = cmac.update(DATA[i]).digest.unpack('H*')[0]
        assert_equal(MAC[i], m, "Test: 1, Vector: #{i + 1}")
      end

      # Test with 1 call of update and same CCM object for each test.
      # There is no reset, because it should be possible to calculate
      # a new mac after digest without reset.
      cmac = OpenSSL::CMAC.new(cipher, KEY)
      DATA.length.times do |i|
        m = cmac.update(DATA[i]).digest.unpack('H*')[0]
        assert_equal(MAC[i], m, "Test: 2, Vector: #{i + 1}")
      end

      # Test with multiple calls of update and new CCM object for each test
      1.upto(DATA.length - 1) do |i|
        1.upto(17) do |c|
          cmac = OpenSSL::CMAC.new(cipher, KEY)
          DATA[i].bytes.each_slice(c) { |w| cmac.update(w.pack('C*')) }
          m = cmac.digest.unpack('H*')[0]
          assert_equal(MAC[i], m, "Test: 3, Vector: #{i + 1}, Tokenlen: #{c}")
        end
      end

      # Test with multiple calls of update and same CCM object for each test
      cmac = OpenSSL::CMAC.new(cipher, KEY)
      1.upto(DATA.length - 1) do |i|
        1.upto(17) do |c|
          DATA[i].bytes.each_slice(c) { |w| cmac.update(w.pack('C*')) }
          m = cmac.digest.unpack('H*')[0]
          assert_equal(MAC[i], m, "Test: 4, Vector: #{i + 1}, Tokenlen: #{c}")
        end
      end
    end

    # Test for Operator <<
    DATA[3].bytes.each_slice(5) { |w| cmac << w.pack('C*') }
    m = cmac.digest.unpack('H*')[0]
    assert_equal(MAC[3], m, 'Test: 5, Vector: 4, Tokenlen: 5')
  end

  def test_cmac_digest
    for cipher in ['aes', 'AES']
      cmac = OpenSSL::CMAC.new(cipher, KEY)
      m = cmac.update(DATA[3]).digest.unpack('H*')[0]
      assert_equal(MAC[3], m, 'Digest with no update')

      cmac.update(DATA[3].b[0...20])
      m = cmac.update(DATA[3].b[20...64]).digest.unpack('H*')[0]
      assert_equal(MAC[3], m, 'Digest after update')

      cmac.update(DATA[3])
      m = cmac.update('').digest.unpack('H*')[0]
      assert_equal(MAC[3], m, 'Empty digest')

      DATA.length.times do |i|
        m = OpenSSL::CMAC.digest(cipher, KEY, DATA[i]).unpack('H*')[0]
        assert_equal(MAC[i], m, "Vector: #{i + 1}")

        m = OpenSSL::CMAC.digest(cipher, KEY, DATA[i], 12).unpack('H*')[0]
        assert_equal(24, m.length, "Vector: #{i + 1} - length")
        assert_equal(MAC[i][0...24], m, "Vector: #{i + 1} - 12")
      end
    end
  end

  def test_cmac_prf
    cmac = OpenSSL::CMAC.new('AES')
    3.times do |i|
      cmac.key = PRF_KEYS[i]
      m = cmac.update(PRF_DATA).digest.unpack('H*')[0]
      assert_equal(PRF_OUTS[i], m, "Vector: #{i + 1}")
    end
  end
end
