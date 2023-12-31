# -*- coding: binary -*-

module Rex

###
#
# Base mixin for all exceptions that can be thrown from inside Rex.
#
###
module Exception
end

###
#
# This exception is raised when a timeout occurs.
#
###
class TimeoutError < Interrupt
  include Exception

  def initialize(msg = "Operation timed out.")
    super(msg)
  end
end

###
#
# This exception is raised when a method is called or a feature is used that
# is not implemented.
#
###
class NotImplementedError < ::NotImplementedError
  include Exception

  def initialize(msg = "The requested method is not implemented.")
    super(msg)
  end
end

###
#
# This exception is raised when a generalized runtime error occurs.
#
###
class RuntimeError < ::RuntimeError
  include Exception
end

###
#
# This exception is raised when an invalid argument is supplied to a method.
#
###
class ArgumentError < ::ArgumentError
  include Exception

  def initialize(message = nil)
    @message = message
  end

  def to_s
    str = 'An invalid argument was specified.'
    if @message
      str << " #{@message}"
    end
    str
  end
end

###
#
# This exception is raised when an argument that was supplied to a method
# could not be parsed correctly.
#
###
class ArgumentParseError < ::ArgumentError
  include Exception

  def initialize(msg = "The argument could not be parsed correctly.")
    super(msg)
  end
end

###
#
# This exception is raised when an argument is ambiguous.
#
###
class AmbiguousArgumentError < ::RuntimeError
  include Exception

  def initialize(name = nil)
    @name = name
  end

  def to_s
    "The name #{@name} is ambiguous."
  end
end

###
#
# This error is thrown when a stream is detected as being closed.
#
###
class StreamClosedError < ::IOError
  include Exception

  def initialize(stream)
    @stream = stream
  end

  def stream
    @stream
  end

  def to_s
    "Stream #{@stream} is closed."
  end
end

##
#
# Socket exceptions
#
##

###
#
# This exception is raised when a general socket error occurs.
#
###
module SocketError
  include Exception

  def to_s
    "A socket error occurred."
  end
end

###
#
# This exception is raised when there is some kind of error related to
# communication with a host.
#
###
module HostCommunicationError
  def initialize(addr = nil, port = nil, reason: nil)
    @host = addr
    @port = port
    @reason = reason
  end

  #
  # This method returns a printable address and optional port associated
  # with the host that triggered the exception.
  #
  def addr_to_s
    if host and port
      host.include?(':') ? "([#{host}]:#{port})" : "(#{host}:#{port})"
    elsif host
      "(#{host})"
    else
      ""
    end
  end

  def to_s
    str = super
    str << " #{@reason}" if @reason
    str
  end

  attr_accessor :host, :port, :reason
end


###
#
# This is a generic exception for errors that cause a connection to fail.
#
###
class ConnectionError < ::IOError
  include SocketError
  include HostCommunicationError
end

###
#
# This exception is raised when a connection attempt fails because the remote
# side refused the connection.
#
###
class ConnectionRefused < ConnectionError
  def to_s
    str = "The connection was refused by the remote host #{addr_to_s}."
    str << " #{@reason}" unless @reason.nil?
    str
  end
end

###
#
# This exception is raised when a connection attempt fails because the remote
# side is unreachable.
#
###
class HostUnreachable < ConnectionError
  def to_s
    str = "The host #{addr_to_s} was unreachable."
    str << " #{@reason}" unless @reason.nil?
    str
  end
end

###
#
# This exception is raised when a connection attempt times out.
#
###
class ConnectionTimeout < ConnectionError
  def to_s
    str = "The connection with #{addr_to_s} timed out."
    str << " #{@reason}" unless @reason.nil?
    str
  end
end

###
#
# This connection error is raised when an attempt is made to connect
# to a broadcast or network address.
#
###
class InvalidDestination < ConnectionError
  def to_s
    str = "The destination is invalid: #{addr_to_s}."
    str << " #{@reason}" unless @reason.nil?
    str
  end
end

###
#
# This exception is raised when an attempt to use an address or port that is
# already in use or not available occurs. such as binding to a host on a
# given port that is already in use, or when a bind address is specified that
# is not available to the host.
#
###
class BindFailed < ::ArgumentError
  include SocketError
  include HostCommunicationError

  def to_s
    str = "The address is already in use or unavailable: #{addr_to_s}."
    str << " #{@reason}" unless @reason.nil?
    str
  end
end

##
#
# This exception is listed for backwards compatibility. We had been
# using AddressInUse as the exception for both bind errors and connection
# errors triggered by connection attempts to broadcast and network addresses.
# The two classes above have split this into their respective sources, but
# callers may still expect the old behavior.
#
##
class AddressInUse < ConnectionError
  def to_s
    str = "The address is already in use or unavailable: #{addr_to_s}."
    str << " #{@reason}" unless @reason.nil?
    str
  end
end


###
#
# This exception is raised when an unsupported internet protocol is specified.
#
###
class UnsupportedProtocol < ::ArgumentError
  include SocketError

  def initialize(proto = nil)
    self.proto = proto
  end

  def to_s
    "The protocol #{proto} is not supported."
  end

  attr_accessor :proto
end


###
#
# This exception is raised when a proxy fails to pass a connection
#
###
class ConnectionProxyError < ConnectionError
  def initialize(host,port,ptype,reason)
    super(host,port)
    self.ptype = ptype
    self.reason = reason
  end

  def to_s
    self.ptype + ": " + self.reason
  end

  attr_accessor :ptype, :reason
end

end

