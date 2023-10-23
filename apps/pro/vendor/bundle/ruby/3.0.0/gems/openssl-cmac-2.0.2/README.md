[![Gem Version](https://badge.fury.io/rb/openssl-cmac.png)](http://badge.fury.io/rb/openssl-cmac)
[![Dependency Status](https://gemnasium.com/SmallLars/openssl-cmac.png)](https://gemnasium.com/SmallLars/openssl-cmac)
[![Build Status](https://travis-ci.org/SmallLars/openssl-cmac.png?branch=master)](https://travis-ci.org/SmallLars/openssl-cmac)
[![Coverage Status](https://coveralls.io/repos/SmallLars/openssl-cmac/badge.png?branch=master)](https://coveralls.io/r/SmallLars/openssl-cmac)
[![Code Climate](https://codeclimate.com/github/SmallLars/openssl-cmac.png)](https://codeclimate.com/github/SmallLars/openssl-cmac)
[![Inline docs](http://inch-ci.org/github/smalllars/openssl-cmac.png)](http://inch-ci.org/github/smalllars/openssl-cmac)

# openssl-cmac

Ruby Gem for
* [RFC 4493 - The AES-CMAC Algorithm](http://tools.ietf.org/html/rfc4493)
* [RFC 4494 - The AES-CMAC-96 Algorithm and Its Use with IPsec](http://tools.ietf.org/html/rfc4494)
* [RFC 4615 - The Advanced Encryption Standard-Cipher-based Message Authentication Code-Pseudo-Random Function-128 (AES-CMAC-PRF-128) Algorithm for the Internet Key Exchange Protocol (IKE)](http://tools.ietf.org/html/rfc4615)

## Installation

Add this line to your application's Gemfile:

    gem 'openssl-cmac'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install openssl-cmac

## Usage

Example 1:

    require 'openssl/cmac'
    mac = OpenSSL::CMAC.digest('AES', 'message', 'key')

Example 2:

    require 'openssl/cmac'
    cmac = OpenSSL::CMAC.new('AES', 'key')
    cmac.update('message chunk 1')
    ...
    cmac.update('message chunk n')
    mac = cmac.digest
