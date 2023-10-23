module Mdm::Loot::Decorator
  def binary?
    sniff
    return true if image?
    return true unless @sniff.kind_of? String
    return true if @sniff.encoding.to_s == "ASCII-8BIT"
    return not(sniff =~ /^[\x09\x0d\x0a\x20-\x7e]+$/)
  end

  def image?
    (name =~ /\.(gif|jpe?g|bmp|png)/i) or
    (ltype =~ /screenshot|graphic|image|picture/)
  end

  def sniff
    # This method returns a small preview of the loot content
    return @sniff if @sniff
    begin
      ::File.open(path, "rb") do |fd|
        @sniff = fd.read(4096)
        if fd.stat.size > 4096
          @sniff << "\r\n\r\n--- Warning: Preview has been truncated, please download to see the full contents ---\r\n"
        end
      end
      @sniff.encode! "UTF-8" # Embracing our new UTF-8 overlords.
    rescue ::Exception # Just bail if anything goes wrong, apparently
    end
    @sniff ||= ( self.data || "" )
  end

  def size
    return @size if @size
    begin
      @size = ::File.size(path)
    rescue ::Exception
      @size = 0
    end
  end

  def text?
    ["text/plain"].include? content_type
  end
end

