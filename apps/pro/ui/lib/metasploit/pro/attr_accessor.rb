module Metasploit::Pro::AttrAccessor
  extend ActiveSupport::Concern

  include Metasploit::Pro::AttrAccessor::Addresses
  include Metasploit::Pro::AttrAccessor::Boolean
  include Metasploit::Pro::AttrAccessor::Integer
end