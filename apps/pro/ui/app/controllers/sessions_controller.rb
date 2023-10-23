class SessionsController < ApplicationController
  before_action :load_workspace, :only => [:index, :show, :console_create, :console_interact, :history]
  before_action :require_admin, :only => [:route, :console_create, :console_interact]

  def index
    @sessions = @workspace.sessions.alive.order("opened_at DESC").includes(:routes)
    @dead_sessions = @workspace.sessions.dead.order("opened_at DESC")
    @active_routes = @sessions.map { |s| s.routes}.join

    respond_to do |format|
      format.html
      format.js {
        render "index_update"
      }
    end
  end

  def show
    begin
      @session = Mdm::Session.find(params[:id])
      compat = Pro::Client.get.session_compatible_modules(@session.local_id)
      @compatible_module_names = (compat ? compat['modules'] : [] )

      unless License.get.supports_agent?
        @compatible_module_names.reject! {|x| x =~ /\/pro\/.*agent.*/ }
      end

      unless License.get.supports_macros?
        @compatible_module_names.reject! {|x| x =~ /\/pro\/.*macro.*/ }
      end

    rescue ActiveRecord::RecordNotFound
      # This can happen often because the Mdm::Session object disappears once it's
      # closed.
      # It would be better if the object persisted, and was marked as "closed"
      redirect_to workspace_sessions_path(@workspace)
      return
    end
    @events  = @session.events
    @host    = @session.host
  end

  def history
    @session = Mdm::Session.find(params[:id])
    @events = @session.events
  end

  def destroy
    @session = Mdm::Session.find(params[:id])

    if ! @session
      render 'invalid_session'
      return
    end

    begin
      @c = Pro::Client.get
      @c.session_stop(@session.local_id)
    rescue => e
      Rails.logger.error "Failed to stop session #{@session.id}: #{e}"
    end

    # Mark it as closed in the database even if the remote side does not
    # know about this session (due to restarts, wrong engine, etc)
    Mdm::Session.update(@session[:id], { :closed_at => Time.now.utc })

    @workspace = @session.workspace
    flash[:notice] = "Session killed"

    respond_to do |format|
      format.html { redirect_to workspace_sessions_path(@workspace) }
    end
  end

  def vnc
    @session  = Mdm::Session.find(params[:id])

    if not @session
      render 'invalid_session'
      return
    end

    @workspace  = @session.workspace
    @sid      = @session.local_id
    @busy     = false
    @port     = params[:port]
    @viewer   = params[:viewer]

    @self_host = request.host

    if @port and @viewer
      case @viewer
      when 'flash'
        render 'vnc_flash', :layout => false
      when 'java'
        render 'vnc_java', :layout => false
      else
        render 'vnc'
      end
      return
    end

    if @session.stype != 'meterpreter'
      flash[:error] = "Invalid session type"
      redirect_to session_path(@session.workspace, @session)
    end

    fwdport = 40000 + rand(20000)
    vncport = 40000 + rand(20000)

    @c = Pro::Client.get
    @c.call('session.meterpreter_script', @sid.to_s, "vnc -O -t -i -c -V -p #{fwdport} -v #{vncport}")

    buff = ''

    begin
      Timeout.timeout(10) do
        while(r = @c.call('session.meterpreter_read', @sid.to_s))
          buff << r['data'] if (r and r['data'])
          break if buff.index("handler")
          select(nil, nil, nil, 0.25)
        end
      end
    rescue ::Timeout::Error
      flash[:error] = "Timed out trying to create VNC session: #{buff}"
      redirect_to session_path(@session.workspace, @session)
      return
    end

    upath = url_for(:action => 'vnc', :id => params[:id])
    redirect_to "#{upath}?port=#{vncport}&viewer=none"
  end

  # Adds and removes session routes via the UI. Mdm::Note that the button that triggers
  # this acts as a toggle switch -- if there are no routes to 0.0.0.0/0, add one,
  # and if there is a route to 0.0.0.0/0, delete it. This will leave other routes
  # (possibly created via the shell) unaffected.
  #
  # In the future, this would be better handled with a popup form that asks for route
  # details and interacts with the Mdm::Session SwitchBoard in a more checkboxy way, but
  # a) proper VPN routing will make this obsolete, and b) advanced users can
  # easily perform more fine-grained route management via the meterpreter console.
  def route
    @session  = Mdm::Session.find(params[:id])

    if not @session
      render 'invalid_session'
      return
    end

    if @session.stype != 'meterpreter'
      flash[:error] = "Invalid session type"
      redirect_to session_path(@session.workspace, @session)
    end

    if @session.routes.where({:subnet => "0.0.0.0", :netmask => "0.0.0.0"}).first
      if @session.del_route
        flash[:notice] = "Deleted route via #{@session.host.address} over #{@session.id}"
      else
        flash[:error] = "Timed out deleting the route."
      end
    else
      if @session.add_route
        flash[:notice] = "Route via #{@target_host} over Mdm::Session #{@session.id} created."
      else
        flash[:error] = "Timed out creating the route."
      end
    end

    redirect_to session_path(@session.workspace, @session)
  end

  def shell
    @session  = Mdm::Session.find(params[:id])

    last_seen_event_id = params[:last_event].to_s.to_i

    # Handle invalid and closed sessions cleanly
    if not @session
      if params[:read] or params[:cmd]
        send_data("console_shutdown();\n", :type => "text/javascript")
      else
        render 'invalid_session'
      end
      return
    end

    @workspace  = @session.workspace
    @host     = @session.host

    @sid      = @session.local_id
    @busy     = false

    rpc_write = nil
    rpc_read  = nil

    case @session.stype
      when 'powershell'
        rpc_write = 'session.shell_write'
        rpc_read  = 'session.shell_read'
      when 'shell'
        rpc_write = 'session.shell_write'
        rpc_read  = 'session.shell_read'
      when 'meterpreter'
        rpc_write = 'session.meterpreter_write'
        rpc_read  = 'session.meterpreter_read'

      cmd = params[:cmd].to_s.strip

      # Process specific commands to avoid problems
      if not cmd.empty?
        case cmd
        when /^irb\s*/
          params[:cmd] = "disabled_irb"
        when /^exit\s*/
          params[:cmd] = "disabled_exit"
        when /^interact\s*/
          params[:cmd] = "disabled_interact"
        when /^background\s*/
          params[:cmd] = "disabled_background"
        when /^shell\s*(.*)/
          args = $1.to_s.strip
          params[:cmd] = "run " + File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "scripts", "meterpreter", "execute_command.rb")) + " #{args}"
        end
      end
    end

    @prompt   = " " + (@session.stype.to_s).capitalize + " > "
    @c ||= Pro::Client.get

    script = ""
    out    = ""
    rep    = "[]"
    err    = false
    last_event_id = nil

    if params[:special] == 'kill'
      @c.call('session.stop', @sid.to_s)
      send_data("console_shutdown();\n", :type => "text/javascript")
      return
    end

    if(params[:cmd] and rpc_write)
      @c.call(rpc_write, @sid.to_s, params[:cmd] + "\n")
    end

    if(params[:read] or params[:cmd])

      begin
        if rpc_read and @session.stype == 'meterpreter'
          stime = Time.now.to_f
          benc = ''
          i = 0
          while(stime + 1.0 > Time.now.to_f)
            i += 1

            r = @c.call(rpc_read, @sid.to_s)

            if not (r and r['data'].length > 0)
              break if not params[:cmd]
              break if out.index("\n")
              next
            end

            benc << r['data']
            out = benc if not benc.empty?
            break if out.length > (1024*256)
            break if out.index("\n")
          end
        end

        if @session.stype == 'shell' || @session.stype == 'powershell'
          @c.call(rpc_read, @sid.to_s)

          max = 64 * 1024
          cnt = 0

          rep = ' ]';

          buff = ''
          @session.events.where('id > ?', last_seen_event_id.to_i ).reverse.each do |ev|
            last_event_id ||= ev.id

            break if cnt > max
            case ev.etype
            when 'output'
              buff = ev.output.to_s.unpack('C*').map{|c| sprintf("%%%.2x", c)}.join + buff
              cnt += ev.output.to_s.length
            when 'command'
              if buff.length > 0
                rep = ", ['output_line', '#{buff}']" + rep
                buff = ''
              end
              rep = ", ['command_line', '#{ev.command.to_s.unpack('C*').map{|c| sprintf("%%%.2x", c)}.join}']" + rep
            end
          end

          if buff.length > 0
            rep = ", ['output_line', '#{buff}']" + rep
          end

          rep = "[  ['output_line', '']" + rep

          last_event_id ||= last_seen_event_id

        end

      rescue Msf::RPC::ServerException => e 
        if @session.closed_at
          out = "Session #{@session.to_param} has been disconnected. Please verify your sessions under sessions tab."
        else
          out = "Session #{@session.to_param} Error: #{e.to_s}"
        end
        err = true
      end

      out = out.unpack('C*').map{|c| sprintf("%%%.2x", c)}.join
      pro = @prompt.unpack('C*').map{|c| sprintf("%%%.2x", c)}.join

      script += "var con_prompt  = unescape('#{pro}');\n"
      script += "var con_update  = unescape('#{out}');\n"
      script += "var con_append  = #{rep};\n"

      if last_event_id
        script += "con_last_event = '#{last_event_id}';\n"
      end

      if err
        script += "console_shutdown();\n"
      end

      send_data(script, :type => "text/javascript")
    else
      @console_title = "Metasploit - Mdm::Session ID # #{@session.to_param} (#{@session.host.address}) #{@session.desc}"
      render 'shell', :layout => false
    end
  end

  def console_create
    unless current_profile.settings['allow_console_access']
      render :partial => "console_access_disabled", :layout => nil
      return
    end

    @c = Pro::Client.get
    r = @c.call("console.create", { "SkipDatabaseInit" => true, "workspace" => @workspace.name })
    @console = r['id']
    @prompt  = r['prompt']
    @busy    = r['busy']

    AuditLogger.admin "#{ip_user} - Metasploit console opened."

    @c.call('console.write', @console, "workspace \"#{@workspace.name}\"\n")
    redirect_to :action => 'console_interact', :workspace_id => @workspace.id, :id => @console, :embed => params[:embed]
  end

  def console_interact
    unless current_profile.settings['allow_console_access']
      render :partial => "console_access_disabled", :layout => nil
      return
    end

    @console = params[:id]
    @c = Pro::Client.get

    @prompt = ""
    script  = ""
    out     = ""

    if(params[:cmd])
      @c.call('console.write', @console, params[:cmd] + "\n")
    end

    if(params[:special])
      case params[:special]
      when 'kill'
        @c.call('console.session_kill', @console)
      when 'detach'
        @c.call('console.session_detach', @console)
      end
    end

    if(params[:tab])
      opts = []
      cmdl = params[:tab]
      out  = ""

      if (not @busy and params[:tab].strip.length > 0)
        r = @c.call('console.tabs', @console, params[:tab])
        if(r and r['tabs'])
          opts = r['tabs']
        end
      end

      if (opts.length == 1)
        cmdl = opts[0]
      else
        if (opts.length > 0)
          cmd_top = opts[0]
          depth   = 0

          while (depth < cmd_top.length)
            match = true
            opts.each do |line|
              next if line[depth] == cmd_top[depth]
              match = false
              break
            end
            break if not match
            depth += 1
          end

          if (depth > 0)
            cmdl = cmd_top[0, depth]
          end

          out << "\n" + opts.map{ |c| ">> " + c }.join("\n")
        end
      end

      tln = cmdl.unpack('C*').map{|c| sprintf("%%%.2x", c)}.join
      script += "var con_tabbed = unescape('#{tln}');\n"
    end

    if(params[:read])

      begin
        benc = ''
        out  = ''

        while(true)
          r = @c.call('console.read', @console)
          @prompt = (r['prompt'] || '')
          @busy   = r['busy'] || false
          break if not (r and not r['data'].nil? and r['data'].length > 0)
          benc << r['data']
          out = benc if not benc.empty?
          break if out.length > (1024*64)
        end
      rescue Msf::RPC::ServerException => e
        out = "Console #{@console} Error: #{e.to_s}"
      end

      out = out.unpack('C*').map{|c| sprintf("%%%.2x", c)}.join
      pro = @prompt.unpack('C*').select{|c|
        c >= 0x20
      }.map{|c| sprintf("%%%.2x", c)}.join

      script += "var con_prompt = unescape('#{pro}');\n"
      script += "var con_update = unescape('#{out}');\n"
      script += "var con_busy = #{@busy};\n"

      send_data(script, :type => "text/javascript")
    else
      @console_title = "Metasploit Console ( #{@console} )"
      render 'shell', :layout => false
    end
  end

  def files
    @session  = Mdm::Session.find(params[:id])

    if ! @session
      render 'invalid_session'
      return
    end

    @workspace  = @session.workspace

    @cwd = normalize_dir(params[:path])
    @cwd = nil if @cwd.to_s.strip.empty?
    @cwd = nil if @cwd.to_s =~ /^([a-z]\:\\|\/)\.\./i
    @ifs = directory_separator

    if @session.stype != 'meterpreter'
      render 'invalid_session'
      return
    end

    begin
      entries = @session.list_files(@cwd)
      sorted_entries = {}
      entries.keys.sort.each do |name|
        sorted_entries[name] = entries[name]
      end
      @dirs  = sorted_entries.select { |name, attrs| attrs['type'] == "dir" and name != "." }
      @files = sorted_entries.select { |name, attrs| attrs['type'] == "fil" }
    rescue Msf::RPC::ServerException
      flash[:error] = "Unable to list files in #{@cwd}"
      redirect_to session_files_path(@session)
    end
  end

  def upload
    @session  = Mdm::Session.find(params[:id])
    @sid      = @session.local_id

    if ! params[:file]
      @path = params[:path]
      if not (@path and @path.length > 0)
        flash[:notice] = "No path specified"
        render 'files', :layout => false
        return
      end

      @task = UploadTask.new(
        :workspace => @session.workspace,
        :username  => current_user.username,
        :path      => @path,
        :sessions  => [@sid]
      )

      render_popup("Upload File to Mdm::Session #{@sid} (#{@path.upcase})", "new_upload")

    else
      @file = params[:file]
      @name = @file.original_filename

      if params[:name] and params[:name].strip.length > 0
        @name = params[:name]
      end

      @path = params[:path]

      if @path.index("/")
        @path += "/" + @name
      else
        @path += "\\" + @name
      end

      @path = @path.gsub("//", "/").gsub("\\\\", "\\")

      @task = UploadTask.new(
        :workspace => @session.workspace,
        :username  => current_user.username,
        :path      => @path,
        :sessions  => [@sid],
        :source    => @file.path
      )

      @task.start
      redirect_to :action => 'files', :path => params[:path]
    end
  end

  def download
    @session  = Mdm::Session.find(params[:id])
    @path     = params[:path]
    @sid      = @session.local_id

    if not (@path and @path.length > 0)
      flash[:notice] = "No path specified"
      render 'files', :layout => false
      return
    end

    ifs = directory_separator

    @task = DownloadTask.new(
      :workspace => @session.workspace,
      :username  => current_user.username,
      :path      => @path,
      :sessions  => [@sid]
    )
    @task.start

    flash[:notice] = "#{@path} downloaded"
    parts = params[:path].split(ifs)
    parts.pop

    case params[:return]
    when 'search'
      redirect_to :action => 'search', :query => params[:query].to_s
    else
      redirect_to :action => 'files', :path => parts.join(ifs)
    end
  end

  def delete
    @session  = Mdm::Session.find(params[:id])
    @path     = params[:path]
    @sid      = @session.local_id
    @c = Pro::Client.get

    ifs = directory_separator

    begin
      r = @c.call('pro.meterpreter_rm', @sid.to_s, @path)
    rescue ::Msf::RPC::ServerException => e
      flash[:error] = "Unable to delete file: #{path} (#{e.to_s})"
      redirect_to session_files_path(@session)
      return
    end

    flash[:notice] = "#{@path} deleted"
    parts = params[:path].split(ifs)
    parts.pop

    case params[:return]
    when 'search'
      redirect_to :action => 'search', :query => params[:query].to_s
    else
      redirect_to :action => 'files', :path => parts.join(ifs)
    end
  end


  def search
    @session  = Mdm::Session.find(params[:id])
    @workspace  = @session.workspace

    if @session.closed_at
      flash[:error] = "Session #{@session.id} is closed"
      redirect_to session_history_path(@workspace, @session)
      return
    end

    @host     = @session.host
    @query    = params[:query].to_s
    @sid      = @session.local_id

    @c = Pro::Client.get

    if @session.stype != 'meterpreter'
      render 'invalid_session'
      return
    end

    begin
      @entries = @c.call('pro.meterpreter_search', @sid.to_s, @query)['entries']
    rescue Msf::RPC::ServerException => e
      flash[:error] = "Search encountered an error: #{e.to_s}"
      redirect_to session_search_path(@session)
    end
  end

  def directory_separator
    return @ifs if @ifs

    @c ||= Pro::Client.get
    result = @c.call("session.meterpreter_directory_separator", @session.local_id)
    @ifs = result["separator"]

    @ifs
  end

  def normalize_dir(dir)
    return "" if dir.nil?
    norm = dir.gsub(/^([a-zA-Z]:)/, '')
    dev = $1 || ""
    # if the user clicked on "Back to parent directory" from the root of a
    # device on a windows session, we'll see something like "C:\\..". On
    # linux, we'll get "/.." which of course is equivalent to "/".  In
    # either case, just send them to the top level (the list of devices in
    # Windows, the root dir in Linux)
    return "" if dir == [dev,".."].join(directory_separator)

    # This takes care of the general case by getting rid of ".." sequences
    # anywhere in the path.
    norm = dev + File.expand_path(norm.gsub("\\", "/"), "/").sub(/^[A-Z]\:/i, '')
    norm.gsub!("/", directory_separator)

    norm
  end
end

