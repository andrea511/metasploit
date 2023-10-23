#
# Adds some hooks to msf's HttpServer mixin to allow Campaigns to be
# tracked in an arbitrary msf HttpServer module.
#
module Custom::CampaignAdditions

  # Fires on every request when a web module is running
  def filter_request_uri(cli, req)
    return unless datastore['CAMPAIGN_ID']
    print_status("Hook: #{self.refname} - #{cli.peerhost}:#{cli.peerport}")

    case req.method
      when "POST"
        pro_hook_process_post_request(req, cli)
      when "GET"
        pro_hook_process_get_request(req, cli)
    end

    # Always return false to allow the request to hit the
    # actual module (non-false prevents it)
    return false
  end

  def pro_hook_process_post_request(req,cli)
    print_status("POST request with data from #{cli.peerhost}")
  end

  # Takes a Rex::Proto::Http::Request and a client and makes a VisitRequest.
  # Then it does a redirect based on VisitRequest#type
  def pro_hook_process_get_request(req, cli)
    SocialEngineering::VisitRequest.framework ||= framework
    visit_request = SocialEngineering::VisitRequest.new(req, cli.peerhost)

    case visit_request.type
    when :tracked_user
      print_status("This human target is already tracked")
    when :redirect
      print_status("Redirected. The human target is now being tracked.")
    when :track_request
      pro_hook_set_param_and_redirect(cli, visit_request)
    when :email_open_track
      pro_hook_track_email_and_respond(cli, visit_request)
    when :landing_page
      print_status("Landing page reached from #{cli.peerhost}:#{cli.peerport}")
    when :unknown_user
      print_status("Unknown user")
      pro_hook_track_new_user(cli,req)
    when :bogus_request
      print_error("It looks like someone is trying to mess with us from #{cli.peerhost}:#{cli.peerport}")
    when :favicon
      print_status("Favicon request -- just ignore")
    end
  end

  def pro_hook_track_new_user(cli,req)
    print_status("Not one of our original targets?")
  end

  def pro_hook_set_param_and_redirect(cli, visit_request)
    print_good("Request is of type :tracking_request -- set param and redirect")
    visit_request.create_visit!
    query_string = visit_request.uri_parts['QueryString'].merge('Redirect' => true)
    send_redirect(cli, visit_request.uri_parts['Resource']+'?'+ query_string.to_param, '')
  end
  
  def pro_hook_track_email_and_respond(cli, visit_request)
    print_good("Tracking email open")
    visit_request.create_email_opening!
    send_response(cli, "")
  end


end

Msf::Exploit::Remote::HttpServer.send(:prepend, Custom::CampaignAdditions)
