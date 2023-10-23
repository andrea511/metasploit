module Pro
class Nginx


require 'fileutils'
require 'rex'

#
# This class generates and manages an nginx instance as part of the Metasploit Pro
# installation.
#

  attr_accessor :options, :config, :pid, :arch

  def initialize(opts={})
    self.options = opts
    self.arch    = determine_arch
    self.config  = generate_config
  end

  def start
    stop()

    odir = ::Dir.pwd

    ::Dir.chdir( nginx_path )

    if self.arch == "win32"
      system("start cmd.exe /c \"#{Rex::Compat.win32_expand_path(binary_path.gsub("/", "\\"))}\" -c #{Rex::Compat.win32_expand_path(self.config.gsub("/", "\\"))}")
    else
      system("chmod 755 \"#{binary_path}\"")
      system("\"#{binary_path}\" -c \"#{self.config}\" >/dev/null 2>&1")
    end

    Dir.chdir(odir)
  end

  def stop
    # The installer uses the engine/scripts/ctl.rb file to stop nginx.
    # It does not normally call this function.
    # If you modify this, modify engine/scripts/ctl.rb as well.
    if self.arch == "win32"
      system("\"#{Rex::Compat.win32_expand_path(binary_path.gsub("/", "\\"))}\" -c #{Rex::Compat.win32_expand_path(self.config.gsub("/", "\\"))} -s stop")
    else
      system("chmod 755 \"#{binary_path}\"")
      system("\"#{binary_path}\" -c \"#{self.config}\" -s stop >/dev/null 2>&1")
    end
  end

  def determine_arch
    arch = 'unknown'
    case RUBY_PLATFORM
    when /x86_64-linux/
      arch = "linux64"
    when /i[3456]86-linux/
      arch = "linux32"
    when /mingw32/
      arch = "win32"
    end
    arch
  end

  def root_path
    @root_path ||= ::File.expand_path( ::File.join( ::File.dirname( __FILE__ ), "..", "..", "..") )
  end

  def base_path
    @base_path ||= root_path
  end

  def nginx_path
    @nginx_path ||= ::File.join(base_path, '..', '..', 'nginx')
  end

  def binary_path
    @binary_path ||= begin
      if self.arch == "win32"
        path = ::File.join( nginx_path, 'sbin', "nginxr7.exe" )
      else
        path = ::File.join( nginx_path, 'sbin', "nginx" )
      end

      path
    end
  end

  def lookup_server_address
    props = ::File.expand_path( ::File.join( base_path, "..", "..", "properties.ini") )
    saddress = "0.0.0.0"
    if ::File.exist?( props )
      ::File.open( props, "r" ) do |fd|
        fd.each_line do |line|

          if line =~ /^nginx_listen_address=(.*)$/
            saddress = $1.to_s
            break
          end
        end
      end
    end
    saddress
  end

  def lookup_server_port
    props = ::File.expand_path( ::File.join( base_path, "..", "..", "properties.ini") )
    sport = 3790
    if ::File.exist?( props )
      ::File.open( props, "r" ) do |fd|
        fd.each_line do |line|

          if line =~ /^apache_server_ssl_port=(\d+)/
            sport = $1.to_i
            break
          end

          if line =~ /^nginx_ssl_port=(\d+)/
            sport = $1.to_i
            break
          end
        end
      end
    end
    sport
  end

  def lookup_worker_port
    props = ::File.expand_path( ::File.join( base_path, "..", "..", "properties.ini") )
    sport = nil
    if ::File.exist?( props )
      ::File.open( props, "r" ) do |fd|
        fd.each_line do |line|
          if line =~ /^thin_port=(\d+)/
            sport = $1.to_i
          end
        end
      end
    end

    conf = ::File.expand_path( ::File.join( base_path, "ui", "conf", "metasploit.conf" ) )
    if ::File.exist?( conf )
      ::File.open( conf, "r" ) do |fd|
        fd.each_line do |line|
          if line =~ /BalancerMember http:\/\/127.0.0.1:(\d+)/
            sport = $1.to_i
          end
        end
      end
    end

    # Default to the webrick standard port for development
    sport ||= 3000

    sport
  end

  def lookup_server_name
    props = ::File.expand_path( ::File.join( base_path, "..", "..", "properties.ini") )
    sname = "localhost"
    if ::File.exist?( props )
      ::File.open( props, "r" ) do |fd|
        fd.each_line do |line|
          if line =~ /^nginx_ssl_name=(.*)$/
            sname = $1.strip
          end
        end
      end
    end
    sname
  end

  def lookup_server_days
    props = ::File.expand_path( ::File.join( base_path, "..", "..", "properties.ini") )
    sdays = 3650
    if ::File.exist?( props )
      ::File.open( props, "r" ) do |fd|
        fd.each_line do |line|
          if line =~ /^nginx_ssl_days=(\d+)/
            sdays = $1.to_i
          end
        end
      end
    end

    # Maximum of 10 years
    [ sdays, 3650 ].min
  end

  def lookup_trust_ssl
    props = ::File.expand_path( ::File.join( base_path, "..", "..", "properties.ini") )
    strust = false
    if ::File.exist?( props )
      ::File.open( props, "r" ) do |fd|
        fd.each_line do |line|
          if line =~ /^trust_ssl=[1ty]/i
            strust = true
          end
        end
      end
    end
    strust
  end

  def lookup_worker_count
    if self.arch == "win32"
      1
    else
      4
    end
  end

  def generate_certificate
    ts = Time.now.utc.to_i
    cakey = OpenSSL::PKey::RSA.new( 4096 ) { }
    cacert = OpenSSL::X509::Certificate.new
    cacert.subject = cacert.issuer = OpenSSL::X509::Name.new([
      ["C",  "US"],
      ['ST', "TX"],
      ["L",  "Austin"],
      ["O",  "Rapid7"],
      ["CN", "MetasploitSelfSignedCA"],
    ])
    cacert.not_before = ts - (3600 * 24 * 30)
    cacert.not_after  = ts + (3600 * 24 * lookup_server_days)
    cacert.public_key = cakey.public_key
    cacert.serial = rand(0xFFFFFFFF)
    cacert.version = 2

    ef = OpenSSL::X509::ExtensionFactory.new
    ef.subject_certificate = cacert
    ef.issuer_certificate = cacert
    cacert.extensions = [
      ef.create_extension("basicConstraints","CA:TRUE", true),
      ef.create_extension("subjectKeyIdentifier", "hash"),
      ef.create_extension("keyUsage", "cRLSign,keyCertSign", true),
    ]
    cacert.add_extension(ef.create_extension("authorityKeyIdentifier","keyid:always"))
    cacert.sign cakey, OpenSSL::Digest.new('SHA256')


    key  = OpenSSL::PKey::RSA.new( 2048 ) { }
    cert = OpenSSL::X509::Certificate.new
    cert.version = 2
    cert.serial = rand(0xFFFFFFFF)

    subject = OpenSSL::X509::Name.new([
      ["C",  "US"],
      ['ST', "TX"],
      ["L",  "Austin"],
      ["O",  "Rapid7"],
      ["CN", lookup_server_name]
    ])

    cert.subject = subject
    cert.issuer  = cacert.subject
    cert.not_before = ts - (3600 * 24 * 30)
    cert.not_after  = ts + (3600 * 24 * lookup_server_days)
    cert.public_key = key.public_key

    ef = OpenSSL::X509::ExtensionFactory.new(nil, cert)
    cert.extensions = [
      ef.create_extension("basicConstraints","CA:FALSE"),
      ef.create_extension("subjectKeyIdentifier","hash"),
      ef.create_extension("extendedKeyUsage","serverAuth"),
      ef.create_extension("keyUsage","keyEncipherment,dataEncipherment,digitalSignature")
    ]
    ef.subject_certificate = cert
    ef.issuer_certificate = cacert

    cert.sign(cakey, OpenSSL::Digest.new('SHA256'))

    # We intentionally do not save the CA key so that it is impossible to
    # sign additional certificates with our self-signed CA

    ::File.open(::File.join(nginx_path, "cert", "ca.crt"), "wb") do |fd|
      fd.write cacert.to_pem
    end

    ::File.open(::File.join(nginx_path, "cert", "server.key"), "wb", 0600) do |fd|
      fd.write key.to_pem
    end

    # Since Windows uses ACL file controls treat it special!
    if self.arch == "win32"
      currentDir = Dir.pwd
      Dir.chdir(::File.join(nginx_path, "cert"))
      system('icacls server.key /inheritance:d')
      system('icacls server.key /remove:g Users')
      system('icacls server.key /remove:g Everyone')
      Dir.chdir(currentDir)
    end

    ::File.open(::File.join(nginx_path, "cert", "server.crt"), "wb") do |fd|
      fd.write cert.to_pem
      fd.write cacert.to_pem
    end

    if lookup_trust_ssl
      trust_cert
    end

    true
  end

  def trust_cert
    capath = ::File.join(nginx_path, "cert", "ca.crt")
    begin
      if self.arch =~ /^win/
        system("certutil -addstore Root #{capath} > NUL")
      elsif self.arch =~ /^linux/
        output = `env -i openssl version -d`
        if output =~ /OPENSSLDIR: "?([^"]+)"?$/
          openssl_dir = $1
        end
        output = `env -i openssl x509 -in #{capath} -noout -hash`
        if output =~ /^([0-9a-f]+)$/
          ca_hash = $1
        end
        if openssl_dir && ca_hash
          cafilename = 'MetasploitSelfSignedCa.pem'
          FileUtils.rm_f(::File.join(openssl_dir, 'certs', cafilename))
          FileUtils.rm_f(::File.join(openssl_dir, 'certs', "#{ca_hash}.0"))
          FileUtils.copy(capath, ::File.join(openssl_dir, 'certs', cafilename))
          FileUtils.ln_s(cafilename, ::File.join(openssl_dir, 'certs', "#{ca_hash}.0"))
        end
      end
    rescue => e
      # we tried our best, but at this point we should ignore errors
      # ssl trust is a nice to have, but it should not prevent Pro from booting
      $stderr.puts "Error importing SSL certificate: #{e}"
    end
  end

  def initialize_ssl
    cacert = ::File.join(nginx_path, "cert", "ca.crt")
    cert = ::File.join(nginx_path, "cert", "server.crt")
    key  = ::File.join(nginx_path, "cert", "server.key")

    # Don't check for cacert because pre 4.6.1 clients won't have it and
    # we don't want to force certificates to be regenerated
    if not (::File.exist?(cert) and ::File.exist?(key))
      generate_certificate
    end
  end


  def generate_config
    initialize_directories
    initialize_apache_migration
    initialize_ssl
    config = %q|

#
# As of version 0.7.53, nginx will use a compiled-in default error log location until it has read the config file:
#  [alert]: could not open error log file: open() "/var/log/nginx/error.log" failed (13: Permission denied)
#

user daemon daemon;
error_log '$BASE$$IFS$logs$IFS$error.log';

worker_processes $WORKER_COUNT$;

pid '$BASE$$IFS$temp$IFS$nginx.pid';
lock_file '$BASE$$IFS$temp$IFS$nginx.lck';

events {
  worker_connections 1024;
}

http {
  error_log '$BASE$$IFS$logs$IFS$error.log';
  access_log '$BASE$$IFS$logs$IFS$access.log';

  # Mime types
  types {
    text/html                             html htm shtml;
    text/css                              css;
    text/xml                              xml;
    image/gif                             gif;
    image/jpeg                            jpeg jpg;
    application/x-javascript              js;
    application/atom+xml                  atom;
    application/rss+xml                   rss;

    text/mathml                           mml;
    text/plain                            txt;
    text/vnd.sun.j2me.app-descriptor      jad;
    text/vnd.wap.wml                      wml;
    text/x-component                      htc;

    image/png                             png;
    image/tiff                            tif tiff;
    image/vnd.wap.wbmp                    wbmp;
    image/x-icon                          ico;
    image/x-jng                           jng;
    image/x-ms-bmp                        bmp;
    image/svg+xml                         svg;

    application/java-archive              jar war ear;
    application/mac-binhex40              hqx;
    application/msword                    doc;
    application/pdf                       pdf;
    application/postscript                ps eps ai;
    application/rtf                       rtf;
    application/vnd.ms-excel              xls;
    application/vnd.ms-powerpoint         ppt;
    application/vnd.wap.wmlc              wmlc;
    application/vnd.google-earth.kml+xml  kml;
    application/vnd.google-earth.kmz      kmz;
    application/x-7z-compressed           7z;
    application/x-cocoa                   cco;
    application/x-java-archive-diff       jardiff;
    application/x-java-jnlp-file          jnlp;
    application/x-makeself                run;
    application/x-perl                    pl pm;
    application/x-pilot                   prc pdb;
    application/x-rar-compressed          rar;
    application/x-redhat-package-manager  rpm;
    application/x-sea                     sea;
    application/x-shockwave-flash         swf;
    application/x-stuffit                 sit;
    application/x-tcl                     tcl tk;
    application/x-x509-ca-cert            der pem crt;
    application/x-xpinstall               xpi;
    application/xhtml+xml                 xhtml;
    application/zip                       zip;

    application/octet-stream              bin exe dll;
    application/octet-stream              deb;
    application/octet-stream              dmg;
    application/octet-stream              eot;
    application/octet-stream              iso img;
    application/octet-stream              msi msp msm;

    audio/midi                            mid midi kar;
    audio/mpeg                            mp3;
    audio/ogg                             ogg;
    audio/x-realaudio                     ra;

    video/3gpp                            3gpp 3gp;
    video/mp4                             mp4;
    video/mpeg                            mpeg mpg;
    video/quicktime                       mov;
    video/x-flv                           flv;
    video/x-mng                           mng;
    video/x-ms-asf                        asx asf;
    video/x-ms-wmv                        wmv;
    video/x-msvideo                       avi;
  }

  default_type application/octet-stream;

  sendfile on;

  upstream pro {
    server 127.0.0.1:$PORT_WORKER$;
  }

  upstream rpc {
    server 127.0.0.1:50505;
  }

  server {
    listen        $LISTEN_ADDRESS$:$PORT_SSL$ ssl;

# IPv6
#    listen        [::]:$PORT_SSL$ ssl;

    server_name      _;
    ssl          on;
    ssl_certificate    '$BASE$$IFS$cert$IFS$server.crt';
    ssl_certificate_key  '$BASE$$IFS$cert$IFS$server.key';
    ssl_session_timeout  10m;
    ssl_protocols    TLSv1.2;
    ssl_ciphers      EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH:EECDH+AES128:RSA+AES128:RSA+AES256:!EECDH+3DES:!RSA+3DES:!MD5;
    ssl_prefer_server_ciphers  on;

    server_tokens off;

    root   '$PRO$$IFS$ui$IFS$public';

    error_page 404 403 /404.html;
    error_page 500 /500.html;
    error_page 502 503 504 /502.html;
    error_page 422 /422.html;
    error_page 497 =301 https://$host:$PORT_SSL$$request_uri;

    client_max_body_size  1024M;

    client_body_temp_path '$BASE$$IFS$temp';
    proxy_temp_path '$BASE$$IFS$temp';
    fastcgi_temp_path '$BASE$$IFS$temp';
    uwsgi_temp_path '$BASE$$IFS$temp';
    scgi_temp_path '$BASE$$IFS$temp';

    location ~ /manifest\.yml {
      deny all;
    }

    location ~* ^/assets/ {
      # Per RFC2616 - 1 year maximum expiry
      # http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
      expires 1y;
      add_header Cache-Control public;

      # Some browsers still send conditional-GET requests if there's a
      # Last-Modified header or an ETag header even if they haven't
      # reached the expiry date sent in the Expires header.
      add_header Last-Modified '';
      add_header ETag '';
      break;
    }

    location /api/ {
      access_log '$BASE$$IFS$logs$IFS$rpc.log';
      error_log '$BASE$$IFS$logs$IFS$rpc.log';

      proxy_set_header  X-FORWARDED_PROTO  https;
      proxy_set_header  X-Forwarded-For    $remote_addr;
      proxy_set_header  X-Forwarded-Server  $http_host;

      proxy_set_header  Host  $http_host;
      proxy_redirect    off;
      proxy_max_temp_file_size  0;
      proxy_buffer_size          128k;
      proxy_buffers            4 256k;
      proxy_busy_buffers_size    256k;
      keepalive_timeout      65;
      proxy_read_timeout      300;
      proxy_pass http://rpc;
      break;
    }

    location / {

      access_log '$BASE$$IFS$logs$IFS$access.log';
      error_log '$BASE$$IFS$logs$IFS$error.log';

      proxy_set_header  X-FORWARDED_PROTO  https;
      proxy_set_header  X-Forwarded-For    $remote_addr;
      proxy_set_header  X-Forwarded-Server  $http_host;

      proxy_set_header  Host  $http_host;
      proxy_redirect    off;

      proxy_max_temp_file_size  0;
      proxy_buffer_size         128k;
      proxy_buffers           4 256k;
      proxy_busy_buffers_size   256k;
      keepalive_timeout      65;

      proxy_read_timeout      300;

      # Only pass through if not static
      if (!-f $request_filename) {
        proxy_pass http://pro;
        break;
      }
    }
  }
}
|

    config.gsub!("$IFS$")  { |m| (self.arch == "win32" ? "\\\\" : "/") }
    config.gsub!("$PRO$")  { |m| os_compat_path(base_path) }
    config.gsub!("$BASE$") { |m| os_compat_path(nginx_path) }
    config.gsub!("$PORT_SSL$")     { |m| lookup_server_port.to_s }
    config.gsub!("$PORT_WORKER$")  { |m| lookup_worker_port.to_s }
    config.gsub!("$WORKER_COUNT$") { |m| lookup_worker_count.to_s }
    config.gsub!("$LISTEN_ADDRESS$") { |m| lookup_server_address }

    ::File.open( ::File.join( nginx_path, "conf", "nginx.conf" ), "w" ) do |fd|
      fd.write config
    end

    ::File.join( nginx_path, "conf", "nginx.conf" )
  end

  def os_compat_path(path)
    if self.arch == 'win32'
      ::Rex::Compat.win32_expand_path(path.gsub("/", "\\")).gsub("\\", "\\\\\\\\")
    else
      path
    end
  end

  def initialize_directories
    ::FileUtils.mkdir_p( ::File.join( nginx_path, "conf") )
    ::FileUtils.mkdir_p( ::File.join( nginx_path, "cert") )
    ::FileUtils.mkdir_p( ::File.join( nginx_path, "logs") )
    ::FileUtils.mkdir_p( ::File.join( nginx_path, "temp") )
  end

  def initialize_apache_migration
    # Bail if Apache is not part of this installation (new builds)
    return if not ::File.directory?( ::File.join( root_path, "apache2") )

    # Bail if we already migrated away from Apache
    return if ::File.exist?( ::File.join( root_path, "apache2", "nginx.mig" ) )

    # Extract the SSL certificates from the Apache installation
    %W{ privkey.pem server.crt server.csr server.key }.each do |fname|
      ::FileUtils.cp( ::File.join( root_path, "apache2", "conf", "certs", fname), ::File.join(nginx_path, "cert", fname) )
    end

    # Kill the Apache service and remove it
    if self.arch == "win32"

      # Stop and uninstall the service in one shot
      s = ::File.join( root_path, "apache2", "scripts", "serviceinstall.bat")
      system("\"#{s}\" REMOVE")

      # Rename the old startup script
      ::FileUtils.cp( ::File.join( root_path, "apache2", "scripts", "servicerun.bat"),  ::File.join( root_path, "apache2", "scripts", "servicerun.old.bat") )

      # Replace the old startup script with a do-nothing
      ::File.open( ::File.join( root_path, "apache2", "scripts", "servicerun.bat"), "w") do |fd|
        fd.write("exit\r\n")
      end
    else
      s = ::File.join( root_path, "apache2", "scripts", "ctl.sh")
      system("\"#{s}\" stop")
      ::FileUtils.cp( ::File.join( root_path, "apache2", "scripts", "ctl.sh"),  ::File.join( root_path, "apache2", "scripts", "ctl.old.sh") )
      ::File.open( ::File.join( root_path, "apache2", "scripts", "ctl.sh"), "w") do |fd|
        fd.write("exit 0\n")
      end
    end

    # Mark the migration with a lock file
    ::File.open( ::File.join( root_path, "apache2", "nginx.mig"), "w") do |fd|
      fd.write("Migrated at #{Time.now.to_s}\n")
    end
  end


end
end
