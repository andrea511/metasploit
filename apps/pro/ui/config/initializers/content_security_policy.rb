SecureHeaders::Configuration.default do |config|
  config.cookies = {
    secure: true, # mark all cookies as "Secure"
    httponly: true, # mark all cookies as "HttpOnly"
    samesite: {
      lax: true # mark all cookies as SameSite=lax
    }
  }

  config.x_frame_options = 'SAMEORIGIN'
  config.x_content_type_options = "nosniff"
  config.x_permitted_cross_domain_policies = "none"
  config.x_xss_protection = "1; mode=block"
  config.x_download_options = "noopen"
  config.csp = {
    default_src: %w('self'),
    img_src:     %w('self' data:),
    frame_src:   %w('self'),
    connect_src: %w('self' https://dev.metasploit.com),
    font_src:    %w('self'),
    media_src:   %w('self'),
    object_src:  %w('self'),
    style_src:   %w('self' 'unsafe-inline' 'inline'),
    script_src:  %w('self' 'unsafe-eval' 'eval' nonce)
  }
end

SecureHeaders::Configuration.override(:phishing) do |config|
  config.x_frame_options = 'SAMEORIGIN'
  config.x_content_type_options = "nosniff"
  config.csp = SecureHeaders::OPT_OUT
end
