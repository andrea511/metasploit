module Mdm::NexposeConsole::RestClient
  extend ActiveSupport::Concern
  included do
    #
    # ASSOCIATIONS
    #
    has_many :scan_templates, class_name: "Nexpose::Data::ScanTemplate", foreign_key: :nx_console_id, dependent: :destroy

  end

  attr_accessor :report_proc, :nsc

  require 'nexpose/util'
  require 'nexpose/api'
  require 'nexpose/api_request'
  require 'nexpose/connection'
  require 'nexpose/api'
  require 'nexpose/error'
  require 'rexml/element'
  require 'rexml/document'

  def nexpose_connect
    @nsc = Nexpose::Connection.new(address, username, password, port)
    nsc.login
    nsc
  end

  def nexpose_disconnect
    begin
      nsc.logout if nsc
    rescue Nexpose::APIError => e
      nil
    end
  end

  def session(refresh = false)
    if @session_id and !refresh
      @session_id
    else
      nexpose_connect
      @session_id = nsc.session_id
      @session_id
    end
  end

  def cookies
    {
      "nexposeCCSessionID" => session
    }
  end

  def post_headers
    cookies.merge({"Content-Type" => "application/json"})
  end

  # Update REST Client from 2.0 to 2.1 for MS-2738
  def url(resource)
    URI.parse("https://#{address}:#{port}/api/2.1/#{resource}").to_s
  end

  def post(resource, payload)
    response = RestClient::Request.execute(
      verify_ssl: false,
      method: :post,
      url: url(resource),
      payload: payload,
      cookies: cookies,
      headers: post_headers
    )
  end

  def get(resource, params = {}, &block)

    json = process_get_request(resource, params, &block)

    # Add rescue block to handle case of GET assets/#{asset_id}/services,
    # which doesn't have a "resouces" component and throws an exception
    begin
      if !json["next_url"].nil? && block
        next_url = Rack::Utils.parse_nested_query(URI.parse(json["next_url"]).query)
        last_url = Rack::Utils.parse_nested_query(URI.parse(json["last_url"]).query)
        next_page = next_url["page"].to_i
        last_page = last_url["page"].to_i
        requests = (next_page..last_page).collect{|page| {resource: resource, params: next_url.merge("page" => page)}}
        get_batch requests, &block
      end
    rescue
      json
    end

    json
  end

  def get_batch(request_array, &block)
    queue = Queue.new
    non_block = true
    request_array.each {|request| queue << request}

    while queue.length > 0
      count = queue.size
      request = queue.pop(non_block)
      process_get_request(request[:resource], request[:params], count, &block)
    end

    # thread_count = queue.size >= 5 ? 5 : queue.size
    #
    # threads = thread_count.times.collect do |n|
    #   Thread.new do
    #     loop do
    #       begin
    #         count = queue.size
    #         request = queue.pop(non_block)
    #         process_get_request(request[:resource], request[:params], count, &block)
    #       rescue ThreadError => e
    #         break
    #       end #begin
    #     end #loop
    #   end #Thread
    # end #collect
    #
    # threads.map &:join
  end

  def get_scan_templates
    get("scan_templates")do |response|
      response["resources"].each do |scan_template_attributes|
        scan_templates.object_from_json(scan_template_attributes)
      end
    end
  end

  private

  def report_get_request(url, count = nil)
    if report_proc
      # mutex.synchronize do
        report_proc.call(:get, {:count => count, :url => url}) if report_proc
      # end
    end
  end

  def report_post_request(url, count = nil)
    if report_proc
      report_proc.call(:post, {:count => count, :url => url}) if report_proc
    end
  end

  def report_error(message)
    if report_proc
      report_proc.call(:error, {:message => "Possible Authentication Error, Retrying"}) if report_proc
    end
  end

  def get_request(resource, params = {})
    response = RestClient::Request.execute(
      verify_ssl: false,
      method: :get,
      url: url(resource),
      cookies: cookies,
      timeout: nil,
      headers: {
        params: params
      })

    #
    # Saving the responses from the nexpose rest api in test mode
    # ref MSP-12809
    #

    # if Rails.env.test? && !resource.include?('definitions')
    #   base_path = Metasploit::Pro::UI::Engine.root.parent.join('test_reports','features')
    #   if defined? TestConfig
    #     time_tag = "nexpose-#{Time.current.strftime('%Y%m%d-%H%M')}"
    #   elsif Dir.glob(base_path.to_s + '/nexpose-*').any?
    #     time_tag =  Dir.glob(base_path.to_s + '/nexpose-*').sort.last[/(nexpose-.*)/,1]
    #   else
    #     time_tag = "nexpose-#{Time.current.strftime('%Y%m%d-%H%M')}"
    #   end
    #   dir_path = base_path.join time_tag
    #   FileUtils.mkdir_p(dir_path.to_s)
    #   file_name = resource.gsub('/','_') + '.json'
    #   file = File.new(dir_path.join(file_name),'w')
    #   file << JSON.pretty_generate(JSON.parse response)
    #   file.close
    # end

    response
  end

  def process_get_request(resource, params = {}, count = nil, &block)
    report_get_request("#{url(resource)}#{"?#{params.to_param}" if params.any?}", count)
    begin
      response = get_request(resource, params)
    rescue RestClient::InternalServerError => e
      report_error("Possible Authentication Error, Retrying")
      session(true)
      report_get_request("#{url(resource)}#{"?#{params.to_param}" if params.any?}", count)
      response = get_request(resource, params)
    end

    json = JSON.parse response

    # Add rescue block to handle case of GET assets/#{asset_id}/services,
    # which doesn't have a "resouces" component and throws an exception
    begin
      json["resources"].collect! { |hsh| singularize_id(resource, hsh) }
    rescue
      json
    end

    if block
      ApplicationRecord.connection_pool.with_connection do |conn|
        block.call(json)
      end
    end

    json
  end

  def singularize_id(resource, hsh)
    hsh["#{resource.split("/").last.singularize}_id"] = hsh["id"]
    hsh.except("id")
  end

end
