# mix this into your class if you want the clone_proxy method
module SocialEngineering
  module CloneProxy
    REQUEST_TIMEOUT = 10

    def grab_url(url)
      @redirects ||= []
      @redirects << url

      uri = ::URI.parse(url) rescue nil unless url.blank?
      return { :error => 'Error: invalid URL.' } unless uri

      cli = Rex::Proto::Http::Client.new(uri.host, uri.port, {}, uri.scheme == 'https')
      return { :error => 'Could not configure HTTP for this URL' } unless cli

      uri.path = '/' if uri.path.blank?
      req = cli.request_raw(
        'uri'   => uri.path,
        'query' => uri.query,
        'headers' => {
          'Referer' => params['referer'] || '',
          'User-Agent' => params['user-agent'] || SocialEngineering::WebPage::DEFAULT_USER_AGENT
        }
      )

      con = cli.connect(REQUEST_TIMEOUT) rescue nil
      return { :error => 'Could not connect to this host' } unless con

      res = cli.send_recv(req, REQUEST_TIMEOUT) rescue nil
      return { :error => 'No response from the host' } unless res

      body = res.body.to_s
      body = Base64.encode64(body) unless res.headers['Content-Type'] =~ /text/i # base 64 encode

      # handle redirects
      if res.headers && [301, 302].include?(res.code)
        return { :error => 'Error: redirect loop detected.' } unless @redirects.include? url
        @redirects << url
        return grab_url res.headers['Location']
      end

      { :body => body, :status => res.code, :headers => res.headers, :uri => uri }
    end

    def clone_proxy
      # reset values if checkboxes are unchecked
      params['referer'] = nil unless params['referer-enabled'] == 'on'
      params['user-agent'] = nil unless params['user-agent-enabled'] == 'on'
      controller = params[:controller].gsub('/', '_').singularize.underscore
      @json = grab_url params[controller][:clone_url]
    
      old_body = @json[:body] # return this if something goes wrong

      # Parse the HTML and normalize the form
      cloned_content =  SocialEngineering::PhishingWebContent.new(@json[:body]) # parse with nokogiri
      cloned_content.delete_form_actions!
      cloned_content.convert_form_methods_to_post!
      doc = cloned_content.doc

      if !@json[:error].present? && doc.present?  # no problems so far...
        if params['suppress-javascript'] == 'on'  # suppress javascript
          doc.css('script').remove()
          doc.xpath("//@*[starts-with(name(),'on')]").remove()
        end
        # rewrite all src and href attributes to use FQDNs
        if params['resolve-relative-urls'] == 'on'
          uri = @json[:uri]
          doc.xpath('//@src|//@href').each do |node|
            node_uri = ::URI.parse(node.value) rescue nil
            next unless node_uri.present?
            # set the scheme so that relative? actually works
            node.value = (uri + node_uri).to_s
          end
        end
        @json[:body] = doc.serialize
      end

      @json[:body] ||= old_body  # just in case the parsing fails?

      render :partial => 'social_engineering/shared/clone_proxy', :formats => [:json]
    end
    
  end
end
