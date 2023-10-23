class Web::HtmlRewrite
  
  def initialize(opts = {})
    @raw_headers = opts[:headers]
    @raw_body = opts[:body]
    @request = opts[:request]
    @request_group = @request.request_group
    @hostname = @request.hostname
    rewrite
  end
  
  attr_reader :body
  # attr_reader :headers
  def headers
    h = {}
    @raw_headers.each do |key, value|
      h[key.to_s] = value.to_s
    end
    h.slice("Content-Type")
  end

  def self.lookup_request(request_id)
     begin
       Web::Request.find(request_id)
     rescue Exception => e
       :invalid_url
     end
   end


  def convert_url(url)
    if url.downcase.include?("javascript:") || url == "#"
      url
    else
      begin
        uri = URI.parse(url)
        if uri.host.nil?
          new_uri = URI.join(@hostname, @request.path, url)
          @request_group.find_or_create_request(new_uri, 'GET').id
        else
          @request_group.find_or_create_request(uri, 'GET').id
        end
        
      rescue URI::InvalidURIError, SocketError => e
        :invalid_url
      end
    end
  end

  def new_location
    "http://localhost:3791/"
  end

  def rewrite
    if ["text/html"].any? {|type| @raw_headers["Content-Type"].downcase.start_with?(type)}
      @noko = Nokogiri::HTML(@raw_body)

      rewrite_links
      rewrite_forms
      rewrite_script_src
      rewrite_img
      
      @body = @noko.to_html(:indent_text => false).gsub("\n",'')
    else
      @body = @raw_body
    end
  end
  
  def rewrite_links
    ["a","link"].each do |css|
      @noko.css(css).each do |link|
        next unless link.attributes.keys.include? "href"
        link.attributes["href"].value = "#{new_location}#{convert_url( link.attributes["href"].value )}"
      end
    end
  end
  
  def rewrite_forms
    @noko.css("form").each do |form|
      form.attributes["action"].value = "#{new_location}#{convert_url(form.attributes["action"].value)}"
    end
  end
  
  def rewrite_script_src
    @noko.xpath("//script/@src").each do |script_tag|
      script_tag.value = "#{new_location}#{convert_url( script_tag.value )}"
    end
    
  end
  
  def rewrite_img
    @noko.css("img").each do |img|
      img.attributes["src"].value = "#{new_location}#{convert_url(img.attributes["src"].value)}"
    end
  end

end
