# -*- coding: binary -*-
require 'rex/socket'
require 'rex/socket/sctp'
require 'rex/io/stream_server'

###
#
# This class provides methods for interacting with a SCTP server.  It
# implements the Rex::IO::StreamServer interface.
#
###
module  Rex::Socket::SctpServer

  include Rex::Socket
  include Rex::IO::StreamServer

  ##
  #
  # Factory
  #
  ##

  #
  # Creates the server using the supplied hash.
  #
  def self.create(hash = {})
    hash['Proto'] = 'sctp'
    hash['Server'] = true
    self.create_param(Rex::Socket::Parameters.from_hash(hash))
  end

  #
  # Wrapper around the base class' creation method that automatically sets
  # the parameter's protocol to SCTP and sets the server flag to true.
  #
  def self.create_param(param)
    param.proto  = 'sctp'
    param.server = true
    Rex::Socket.create_param(param)
  end

  #
  # Accepts a child connection.
  #
  def accept(opts = {})
    t = super()

    # jRuby compatibility
    if t.respond_to?('[]')
      t = t[0]
    end

    if (t)
      t.extend(Rex::Socket::Sctp)
      t.context = self.context

      pn = t.getpeername_as_array

      # We hit a "getpeername(2)" from Ruby
      return nil unless pn

      t.peerhost = pn[1]
      t.peerport = pn[2]

      ln = t.getlocalname

      t.localhost = ln[1]
      t.localport = ln[2]
    end

    t
  end

end

