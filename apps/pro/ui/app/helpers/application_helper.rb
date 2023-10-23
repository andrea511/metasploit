module ApplicationHelper

  #
  # Adds an element to a form named after the given record
  #
  # Renders a partial named after the record's singular name + "_fields"
  #
  def link_to_add_field(f, record_or_name, opts={})
    case record_or_name
    when Symbol, String
      # Force plural so classify works.  Inflector is smart enough not to
      # double-pluralize, so this should always be correct.  Using to_s here
      # allows the argument to be either a string or a sym.
      record_or_name = record_or_name.to_s.pluralize
      if opts[:class]
        klass = opts[:class]
      else
        klass = Kernel.const_get(record_or_name.classify)
      end
      object = klass.new
      object_name = record_or_name
    else
      object = record_or_name
      object_name = ActionController::RecordIdentifier.plural_class_name(object)
    end

    singular = object_name.singularize
    partial = singular+"_fields"
    if (opts[:controller])
      partial = opts[:controller].to_s + "/" + partial
    end
    fields = f.fields_for(object_name, object, :child_index => "new_object") do |builder|
      render partial, :f => builder
    end
    link_to("Add #{singular.titleize}", "", data: {new_fields: fields}, class: 'add-new-fields')
  end

  #
  # content_fors
  #

  def title(page_title)
    content_for(:title) { page_title }
  end

  def breadcrumb(*crumbs)
    content_for(:breadcrumb) do
      crumb_html = home_link
      crumbs.each_with_index do |c, i|
        if (i == crumbs.length-1)
          # wrap the last crumb in a span
          crumb_html << content_tag(:span, c, :class => 'last')
        else
          crumb_html << c
        end
        crumb_html << " "
      end
      crumb_html
    end
  end

  def include_javascript(file)
    content_for(:head) { javascript_include_tag file }
  end

  #
  # Wrap gon code in a closure so we have the correct $ jQuery context
  #
  # @return [String] the javascript tag with the gon javascript
  def include_gon_jquery(opts={})
    opts.merge!(need_tag:false)

    init_gon = <<eos
    jQuery(function($){
      #{Gon::Base.render_data(opts)}
    })
eos

    nonced_javascript_tag init_gon
  end

  #Includes RequireJS Hook at the head of the view
  #
  #file - The String name of the require config file
  #
  #Returns nothing.
  def include_require(file)
    #Funky Symbol Syntax b/c of the dash
    content_for(:head) { javascript_include_tag javascript_path('require'), :'data-main' => javascript_path(file) }
  end

  def init_require(app_path)
    init_call = <<eos
      jQuery(document).bind('requirejs-ready', function(){
        jQuery(document).ready(function() {
          initProRequire(
          [
            'jquery',
            '#{javascript_path(app_path)}'
          ],
          function($, App){
            app = new App;
            app.start();
          });
        });
      });
eos
    nonced_javascript_tag init_call
  end

  # Includes a stylesheet in the head of the view.
  #
  # file - The String name of the stylesheet.
  #
  # Returns nothing.
  def include_stylesheet(file)
    content_for(:view_stylesheets) { stylesheet_link_tag file }
  end

  # Includes the jQuery library (and jquery-application.js) for this view.
  #
  # Returns nothing.
  def include_jquery
    javascript_include_tag('jquery')
  end

  # Includes the jQuery UI library (and the appropriate version of jQuery)
  # for this view.
  #
  # Returns nothing.
  def include_jquery_ui
    #Use this version to enable jquery migration warnings
    jquery_migrate = javascript_include_tag('jquery_migrate/jquery-migrate')
    #jquery_migrate = javascript_include_tag('jquery_migrate/jquery-migrate.min')

    [javascript_include_tag('vendor/jquery-2.1.1'),
     javascript_include_tag('jquery_ujs'),
     jquery_migrate,
     javascript_include_tag('jquery-ui-1.8.18.custom.min'),
     javascript_include_tag('jquery_timepicker/jquery-ui-timepicker-addon.min'),
     javascript_include_tag('jquery_timepicker/jquery-ui-sliderAccess')
    ].each do |inc|
      content_for(:jquery) { inc }
     end
  end

  # Includes any javascripts specific to this view. The hosts/show view
  # will automatically include any javascripts at public/javascripts/hosts/show.js.
  #
  # @return [void]
  def include_view_javascript
    include_view_javascript_named('shared')

    #
    # Sprockets treats index.js as special, so the js for the index action must be called _index.js instead.
    # http://guides.rubyonrails.org/asset_pipeline.html#using-index-files
    #

    controller_action_name = controller.action_name

    if controller_action_name == 'index'
      safe_action_name = '_index'
    else
      safe_action_name = controller_action_name
    end

    include_view_javascript_named(safe_action_name)
  end

  # Includes the named javascript for this controller if it exists.
  #
  # @return [void]
  def include_view_javascript_named(name)
    controller_path = controller.controller_path
    extensions = ['.coffee', '.js.coffee', '.js.coffee.erb']
    javascript_controller_pathname = Rails.root.join('app', 'assets', 'javascripts', controller_path)

    pathnames = extensions.collect { |extension|
      javascript_controller_pathname.join("#{name}#{extension}")
    }

    if pathnames.any?(&:exist?)
      path = File.join(controller_path, name)

      content_for(:view_javascript) do
        javascript_include_tag path
      end
    end
  end

  #
  # common links
  #

  def home_link
    link_to "Home", root_path
  end

  def admin_users_link
    link_to "User Administration", admin_users_path, :id => 'admin-users-link'
  end

  def workspaces_link
    link_to "Workspaces", workspaces_path
  end

  def workspace_link
    link_to h(@workspace.name), workspace_path(@workspace)
  end

  def hosts_link
    link_to "Hosts", hosts_path(@workspace)
  end

  def credentials_link
    link_to "Credential Management", (workspace_credentials_path(@workspace) + '#creds')
  end

  def bruteforce_guess_link
    link_to "Bruteforce", (workspace_brute_force_guess_index_path(@workspace))
  end

  def task_chains_link
    link_to "Task Chains", workspace_task_chains_path(@workspace)
  end

  def task_chain_link
    link_to h(@task_chain.name), workspace_task_chain_path(@workspace, @task_chain)
  end

  def loots_link
    link_to "Captured Data", workspace_loots_path(@workspace)
  end

  def notes_link(options = {})
    link_to "Notes", workspace_notes_path(@workspace)
  end

  def services_link(options = {})
    link_to "Services", workspace_services_path(@workspace)
  end

  def vulns_link(options = {})
    link_to "Disclosed Vulnerabilities", workspace_vulns_path(@workspace)
  end

  def workspace_web_vulns_link(options = {})
    link_to "Web Vulnerabilities", workspace_web_vulns_path(@workspace)
  end

  def related_modules_link(options = {})
    link_to "Applicable Modules", workspace_related_modules_path(@workspace)
  end

  def host_link
    link_to h(@host.name.blank? ? @host.address : @host.title), host_path(@host)
  end

  def imports_link
    link_to "Imports", new_workspace_import_path(@workspace)
  end

  def sessions_link
    link_to "Sessions", workspace_sessions_path(@workspace)
  end

  def session_link
    link_to "##{@session.id}", session_path(@session.workspace.id, @session.id)
  end

  def reports_link
    link_to "Reports", workspace_reports_path(@workspace)
  end

  def exports_link
    link_to "Exports", workspace_exports_path(@workspace)
  end

  def events_link
    link_to "Events", workspace_events_path(@workspace)
  end

  def modules_link
    link_to "Modules", modules_path(@workspace)
  end

  def rc_scripts_link
    link_to "Resource Scripts", rc_scripts_path(@workspace)
  end

  def module_link
    link_to h(@module.title), new_module_run_path(@workspace, @module.fullname)
  end

  def tags_link
    link_to "Tags", workspace_tags_path(@workspace)
  end

  def tasks_link
    link_to "Tasks", tasks_path(@workspace)
  end

  def task_link
    link_to "Task #{@task.id}", task_detail_path(@workspace, @task)
  end

  # TODO: remove after tearing out non-social engineering controllers
  def campaigns_link
    link_to("Campaigns", workspace_campaigns_path(@workspace))
  end

  # TODO: remove after tearing out non-social engineering controllers
  def campaign_link
    link_to h(@campaign.name), workspace_campaign_path(@workspace, @campaign)
  end

  def social_engineering_campaigns_link
    link_to("Campaigns", workspace_social_engineering_campaigns_path(@workspace))
  end

  def social_engineering_campaign_link
    link_to h(@campaign.name), workspace_social_engineering_campaign_path(@workspace, @campaign)
  end

  def social_engineering_email_templates_link
    link_to("Email Templates", workspace_social_engineering_email_templates_path)
  end

  def social_engineering_web_templates_link
    link_to("Web Templates", workspace_social_engineering_web_templates_path)
  end

  def social_engineering_target_lists_link
    link_to('Target Lists', workspace_social_engineering_target_lists_path(@workspace))
  end

  def social_engineering_files_link
    link_to('Malicious files', workspace_social_engineering_files_path(@workspace))
  end

  def social_engineering_campaign_visits_link
    link_to h("Visits"), workspace_social_engineering_campaign_visits_path(@workspace, @campaign)
  end

  def web_link
    link_to "Web Applications", web_sites_path(@workspace)
  end

  def bruteforce_link
    link_to "Bruteforce", new_bruteforce_path(@workspace)
  end

  def web_vulns_link
    site = @site || @vuln.web_site
    host,port,vhost = site.service.host.address, site.service.port, site.vhost
    link_to "Vulns(#{host}:#{port})", web_vulns_path(@workspace, site)
  end

  def web_vuln_link
    link_to(@vuln, web_vuln_path(@workspace, @vuln))
  end

  #
  # external links
  #

  def rapid7_contact_link
    link_to "Contact Rapid7", "https://www.rapid7.com/contact/"
  end

  def rapid7_purchase_form(product_key)
    url = "http://www.rapid7.com/store/metasploit/license.jsp"

    # don't use form_tag here because we don't want the authenticity_token param to be added
    content_tag(:form, :action => url, :style => "display:none", :id => "purchase_form", :method => "post") do
      hidden_field_tag("pk", @license.product_key) +
        hidden_field_tag("buyid", "EXPRESS")
    end
  end

  # @return [String] a version of the edition name suitable for use in html id or class
  #   attributes
  def edition_name
    License.get.activated? ? License.get.edition.downcase : "none"
  end

  #
  # logo images
  #
  def logo_image_error
    img_file = "logo_none_white.png"
    image_tag(img_file, :alt => "Metasploit")
  end

  #
  # misc
  #

  # Puts the help bubble into the top menu
  def notification_menu
    if instance_variable_defined?(:@profile) and @profile.present?
      if @profile.settings["automatically_check_updates"]
        if @profile.update_available? || @profile.update_proxy_error?
          new_notifications_count = 1
          content_tag(:li, :class => "menu", :id => "notification-menu") do
            icon("notification_bubble") +
              content_tag(:ul, :class => "sub-menu") do
              update_message = if @profile.update_available?
                                 link_to "An update is available.", updates_path
                               elsif @profile.update_proxy_error?
                                 admin_message = current_user.admin? ? "" : "ask your administrator to "
                                 link_to("Unable to contact the update server. Please #{admin_message}update your proxy settings or disable automatic update checking.",
                                         settings_path, :style => "overflow: visible; height: auto;")
                               else
                                 "<a href='#'>No updates available.</a>"
                               end
              content_tag(:li, :style => "height: auto;") { update_message }
              end +
            new_notifications_count.to_s
          end
        end
      end
    end
  end

  #
  # Helpers for Upsell Screens
  #

  def get_learn_url
    if License.get.express?
      "https://community.rapid7.com/docs/DOC-2280#{get_analytics_query_params}"
    else
      "https://community.rapid7.com/docs/DOC-2275#{get_analytics_query_params}"
    end
  end

  def get_upgrade_url
    "http://www.rapid7.com/register/metasploit-trial.jsp#{get_analytics_query_params}"
  end

  def get_analytics_query_params
    "?product=#{License.get.current_product_type}&return_path=#{root_url+licenses_path.gsub('/','')}&EmailAddress=#{current_user.email}&utm_source=#{License.get.current_product_type}&utm_medium=cta&utm_content=#{get_analytics_content}&utm_campaign=msinproducttrial"
  end

  def get_analytics_content
    controller_codes = {
      Wizards::PayloadGenerator::FormController => 'avevasion'
    }

    case controller_name
    when 'tags'
      'tagging'
    when 'tasks'
      case action_name
      when 'new_bruteforce'
        'bruteforce'
      when 'new_exploit'
        'smart_exploitation'
      when 'new_report'
        'reporting'
      when 'new_collect_evidence'
        'evidence_collection'
      when 'new_tunnel'
        'vpnpivot'
      when 'new_replay'
        'session_replay'
      end
    when 'reports'
      'reporting'
    when 'campaigns'
      'social_engineering'
    when 'web'
      'web_apps'
    when 'task_chains'
      'task_chains'
    when 'apps'
      'meta_modules'
    else
      controller_codes[controller.class]
    end
  end

  def render_upsell_screen
    case controller_name # defined as an attribute of Controller
    when 'guess'
      render :partial => 'generic/upsell/bruteforce'
    when 'imports'
      render :partial => 'generic/upsell/sonar'
    when 'tasks'
      case action_name # defined as an attribute of Controller
      when 'new_replay'
        render :partial => 'generic/upsell/session_replay'
      when 'new_exploit'
        render :partial => 'generic/upsell/smart_exploitation'
      when 'new_collect_evidence'
        render :partial => 'generic/upsell/evidence_collection'
      when 'new_tunnel'
        render :partial => 'generic/upsell/vpn_pivoting'
      end
    when 'reports'
      render :partial => 'generic/upsell/reporting'
    when 'campaigns'
      render :partial => 'generic/upsell/social_engineering'
    when 'web'
      render :partial => 'generic/upsell/web_apps'
   when 'task_chains'
      render :partial => 'generic/upsell/task_chains'
    when 'apps'
      render :partial => 'generic/upsell/meta_modules'
    end
  end

  def required_class(obj)
    obj.required? ? "required" : ""
  end

  def blank_if_zero(x, zero_str='')
    (x == 0) ? zero_str : x
  end

  def dash_if_empty(s, empty_str='-')
    (s.nil? or s.empty?) ? empty_str : s
  end

  def if_blank(s, blank_str)
    (s.blank?) ? blank_str : s
  end

  def class_for_tab(tab)
    if tab == :tasks
      %w{tasks task_chains}.include?(controller_name) ? 'sel tasks' : 'tasks'
    elsif License.get.supports_social_engineering? && tab == :campaigns
      %w{campaigns target_lists email_templates web_templates campaign_files}.include?(controller_name) ? 'sel campaigns' : 'campaigns'
    elsif tab == :apps
      %w{apps app_runs}.include?(controller_name) ? "sel apps" : "apps"
    elsif tab != :analysis
      (controller_name == tab.to_s) ? "sel #{tab}" : tab.to_s
    else
      %w{hosts loots vulns notes services}.include?(controller_name) ? "sel analysis" : tab.to_s
    end
  end

  def link_for_ref(type, ref)
    Mdm::Ref.lookup_url(type,ref)
  end

  def sortable_th(name, sort_key)
    current_sort_key = params[:sort_by]
    current_sort_dir = params[:sort_dir] || "asc"

    link_params = params.merge(:sort_by => sort_key)
    link_params.delete("sort_dir")

    if current_sort_key == sort_key
      link_params[:sort_dir] = "desc" if current_sort_dir == "asc"
      a_class = current_sort_dir
      th_class = "sorted #{sort_key}"
    else
      a_class = nil
      th_class = sort_key
    end

    # sliced using common known params this may need further refactor
    link_params = link_params.slice(:controller, :action, :workspace_id, :sort_by, :sort_dir, :only_path, :utf8, :q, :authenticity_token, :class, :ignore_pagination).permit!
    link = link_to name.html_safe, link_params, :class => [a_class, 'table-sort'].join(' ')
    content_tag :th, link, :class => th_class
  end

  def link_for_service_name(svc)
    txt = h(svc.name)

    proto = case svc.name
            when 'http', 'https', 'ftp', 'telnet', 'ssh', 'vnc', 'smb'
              svc.name
            when 'rlogin', 'login'
              'rlogin'
            when 'msrdp'
              'rdp'
            else
              nil
            end

    if proto
      link_to txt, "#{proto}://#{svc.host.address}:#{svc.port}/", :target => "_blank"
    else
      txt
    end
  end

  # Returns nil if the loot id is not valid, or if the file at the
  # path is not readable. Otherwise, returns the file path of the loot
  def loot_valid?(lid)
    return unless lid
    loot = Mdm::Loot.find(lid)
    if loot
      if ::File.readable?(loot.path)
        loot
      end
    end
  end

  # Dumps the ssh key to the browser as an application/octet-stream (thanks to the file
  # suffix)
  def link_for_ssh_key_loot(key,key_type)
    key_loot = nil
    Mdm::Loot.where(workspace_id: @workspace.id).each do |k|
      next unless k.info =~ /#{key}/
        if key_type == "ssh_pubkey"
          next unless k.ltype =~ /public/
        elsif key_type == "ssh_key"
          next unless k.ltype =~ /private/
        end
      key_loot = k
      break
    end
    if key_loot and loot_valid?(key_loot.id) # Guard against nils
      link_to key_loot.info, loot_path(key_loot)
    else
      key
    end
  end

  # Dumps the loot data to the browser. In most cases, it's text, and will
  # render inline as text/plain. Sometimes it's binary, so it'll trigger
  # a download event as application/octet-stream.
  def link_for_loot(lid)
    loot = loot_valid?(lid)
    if loot
      link_to h(loot.info || loot.ltype), loot_path(loot)
    else
      ""
    end
  end

  def loot_filesize(lid)
    loot = loot_valid?(lid)
    if loot
      ::File.size(loot.path)
    else
      0
    end
  end

  # Take the latest, readable loot record for the pwdump, and hand that to
  # the user. Should we be doing send_file? I don't think so, if they want
  # that, they can just download creds or whatever.
  def link_for_smb_hash_loot(hid,hash)
    pwdump = nil
    likely_loots = Mdm::Loot.where(ltype: "host.windows.pwdump", host_id: hid)
    likely_loots.sort {|a,b| b.id <=> a.id}.each do |ll|
      pwdump = loot_valid?(ll)
      break if pwdump
    end
    if pwdump
      link_to h(hash), loot_path(pwdump)
    else
      hash
    end
  end

  # Creates a fakey kind of struct using an array of either:
  # [:exploit, host, modname, session.id] for exploit-sourced
  # or
  # [:cred, host, port, user, type, pass] for credential-sourced
  #
  # Used by credential_source_formatted to spit out either a host:user
  # or a link to an exploit.
  def credential_source_info_array(cred)
    return [] unless cred.source_id
    if cred.source_type == "exploit"
      s = Mdm::Session.find_by_id(cred.source_id)
      if s
        return [:exploit,s.host.address,s.via_exploit,s.id]
      else
        return [:exploit]
      end
    else
      s = Mdm::Cred.find_by_id(cred.source_id)
      return [] unless s && s.service && s.service.host && s.service.host.address
      arr = [
        s.service.host.address,
        s.service.port,
        s.user,
        s.ptype,
        s.pass
      ]
      if arr == [cred.service.host.address,cred.service.port,cred.user,cred.ptype,cred.pass]
        return []
      else
        arr.unshift :cred
        return arr
      end
    end
  end

  # Create a link to an exploit, or some text indicating a previously
  # cracked credential. For sourceless creds, use <guessed>, for
  # exploits that somehow don't have sessions use <exploit>, and for
  # arrays without a decorator at index 0, use <unknown> (these last
  # two should really never hit, and imply an inconsistent database.
  def credential_source_formatted(cred)
    arr = credential_source_info_array(cred)
    if arr.empty?
      if cred.active
        if cred.ptype =~ /^password/
          return h("<guessed>")
        else
          return h("<imported>") # Can't guess these, must have been imported.
        end
      else
        return h("<unverified>")
      end
    end
    case arr[0]
    when :cred
      h arr[1,3].join(":")
    when :exploit
      if arr.last.kind_of? Integer
        sid = arr.last
        addr = arr[1]
        modname = arr[2].split(/[\x5c\x2f]/).last
        link_to(h("Session #{sid}"), session_reopen_path(@workspace, sid), {:title => "#{addr}/#{modname}"})
      else
        h("<exploit>")
      end
    else
      h "<unknown>"
    end
  end

  # recent_workspaces returns a list of most recently used workspaces
  #   it checks the latest `updated_at` value on the workspace, the
  #   workspace's most recently used host, the workspace's most
  #   recently created event, or the workspace's most recently
  #   updated service
  # a better solution would be to add touch => true to the belongs_to
  #   association definition in Hosts, Services, and Events... however
  #   this would affect performance on large imports and is not feasible
  def recent_workspaces(exclude = nil, limit = 5)
    workspaces = current_user.accessible_workspaces
    # remove the Mdm::Workspace passed in as the 'exclude' arg
    if exclude.present?
      workspaces = workspaces.where('id != (?)', exclude.id)
    end
    workspaces = workspaces.select(
      # grab the highest value from 4 sub-queries and assign it alias 'sort_me'
      # if only SQL had a Math.max-esque function (not aggregate function)
      '*,
        CASE WHEN max_updated_at1 >= max_updated_at2 AND
          max_updated_at1 >= max_updated_at3 AND
          max_updated_at1 >= workspaces.updated_at THEN
          max_updated_at1
        WHEN max_updated_at2 >= max_updated_at1 AND
          max_updated_at2 >= max_updated_at3 AND
          max_updated_at2 >= workspaces.updated_at THEN
          max_updated_at2
        WHEN max_updated_at3 >= max_updated_at1 AND
          max_updated_at3 >= max_updated_at2 AND
          max_updated_at3 >= workspaces.updated_at THEN
          max_updated_at3
        ELSE
          workspaces.updated_at
        END AS sort_me'
    )
    # we want to sort the workspaces by the most recent of the following set
    # timestamp: 1. workspace->most_recent_host->updated_at,
    #            2. workspace->most_recent_service->updated_at
    #            3. workspace->most_recent_event->updated_at
    #            4. workspace->updated_at
    max_value_subqueries = [
      # each element represents a subquery to find the most recent
      # 'updated_at' value from different associations
      Mdm::Host.select('workspace_id, MAX(updated_at) AS max_updated_at1')
        .group('workspace_id'),
      Mdm::Host.joins(:services).select('workspace_id, MAX(services.updated_at) AS max_updated_at2')
        .group('workspace_id'),
      Mdm::Event.select('workspace_id, MAX(updated_at) AS max_updated_at3')
        .group('workspace_id')
    ]
    # inject the subqueries into the SELECT clause to use as variables
    workspaces = workspaces.joins(
      max_value_subqueries.each_with_index.map { |subquery, idx|
        "LEFT JOIN (#{subquery.to_sql}) AS sq#{idx} ON sq#{idx}.workspace_id=workspaces.id "
      }.join
    )
    workspaces.order("sort_me DESC").limit(limit)
  end

  def badge_tag(n)
    return "" if n == 0
    content_tag :span, n, :class => "badge"
  end

  # used for alternating <tr> colors
  def row_cycle
    cycle("odd", "even", :name => "rows")
  end

  def display_none_if bool
    bool ? "display:none" : ""
  end

  def os_to_icon(str)
    ico = case str.to_s.downcase
          when /vmware/
            'vm_logo.png'
          when /aix/
            'aix_logo.png'
          when /apple|osx|os x|macintosh/
            'apple_logo.png'
          when /beos/
            'beos_logo.png'
          when /openbsd/
            'openbsd_logo.png'
          when /freebsd/
            'freebsd_logo.png'
          when /bsd/
            'bsd_logo.png'
          when /cisco/
            'cisco_logo.png'
          when /hpux|hp300|hp-ux/
            'hp_logo.png'
          when /ibm/
            'ibm_logo.png'
          when /linux|debian|ubuntu|redhat|suse/
            'linuxlogo.png'
          when /print/
            'printer_logo.png'
          when /route/
            'router_logo.png'
          when /solaris/
            'solaris_logo.png'
          when /sunos/
            'sunos_logo.png'
          when /windows/
            'winlogo.png'
          else
            'unknown_logo.png'
          end

    ActionController::Base.helpers.image_path('icons/os/' + ico)
  end

  def show_hide_link(hidden_element_id, title="show")
    link_to title, '', data: {show_hide_element: hidden_element_id}, class: 'show_hide'
  end

  # TODO: This is implemented everywhere like so:
  #
  #   add_disable_overlay([:pro, :express]) if not @licensed
  #
  # The licensed check should be a part of the method.
  #
  # With the great license combining, maybe this should be less conditional?
  def add_disable_overlay(supported=[])
    content_for :head do
      "<meta name='msp:unlicensed' content='true' />".html_safe
    end
  end

  def password_mask(str,bool=false)
    @config ||= {}
    @config[:mask] ||= false
    return "<masked>" if (@config[:mask] || bool)
    if str.nil? || str.empty?
      "*BLANK PASSWORD*"
    else
      str
    end
  end

  # Overload h() to convert all output to valid UTF8
  # TODO: This will affect Rails 3 upgrade.
  def h(str)
    str = str.to_s
    if str.respond_to?('encode')
      str = str.encode(::Encoding::BINARY, **{ :invalid => :replace, :undef => :replace, :replace => '?' })
    end

    super(str)
  end

  #
  # Generate pagination links
  #
  # Parameters:
  #   :name:: the kind of the items we're paginating
  #   :items:: the collection of items currently on the page
  #   :count:: total count of items to paginate
  #   :offset:: offset from the beginning where +items+ starts within the total
  #   :page:: current page
  #   :num_pages:: total number of pages
  #
  def page_links(opts={})
    link_method = opts[:link_method]
    if not link_method or not respond_to? link_method
      raise RuntimeError.new("Need a method for generating links")
    end
    name      = opts[:name] || ""
    items     = opts[:items] || []
    count     = opts[:count] || 0
    offset    = opts[:offset] || 0
    page      = opts[:page] || 1
    num_pages = opts[:num_pages] || 1

    page_list = ""
    1.upto(num_pages) do |p|
      if p == page
        page_list << content_tag(:span, :class=>"current") { h page }
      else
        page_list << self.send(link_method, p, { :page => p })
      end
    end
    content_tag(:div, :id => "page_links") do
      content_tag(:span, :class => "index") do
        if items.size > 0
          "#{offset + 1}-#{offset + items.size} of #{h pluralize(count, name)}" + "&nbsp;"*3
        else
          h(name.pluralize)
        end.html_safe
      end +
        if num_pages > 1
          self.send(link_method, '', { :page => 0 }, { :class => 'start' }) +
            self.send(link_method, '', { :page => page-1 }, {:class => 'prev' }) +
            page_list +
            self.send(link_method, '', { :page => [page+1,num_pages].min }, { :class => 'next' }) +
            self.send(link_method, '', { :page => num_pages }, { :class => 'end' })
        else
          ""
        end
    end
  end

  def submit_checkboxes_to(name, path, html={})
    html[:class] ||= ''
    html[:class] += ' submit_checkboxes'
    link_to(name, "", data: {path: path, token: form_authenticity_token}, **html)
  end

  # Includes the protovis.js graphing library for this view.
  #
  # Returns nothing
  def include_javascript_graphing_lib
    content_for(:head) { javascript_include_tag('protovis.min') }
  end

  def icon_for_filename(name)
    case name.downcase.split(".").last
    when /txt|ini|log/
      return "text"
    when /jpg|jpeg|png|bmp|tif|tiff|gif/
      return "picture"
    when /bat|pif|com|exe|cpl|scr/
      return "application"
    when /rtf|doc|docx|wri|odp|odt/
      return "doc"
    when /pdf/
      return "pdf"
    when /ppt|pptx/
      return "ppt"
    when /xls|xlsx|csv/
      return "xls"
    when /manifest|dll|ocx|tlb/
      return "dll"
    else
      return "file"
    end
  end

  # Generate the markup necessary for an icon image.
  #
  # name    - The String name of the icon file, sans '.png'.
  # options - The Hash of options to pass to +image_tag+.
  #
  # Returns the String markup.
  def icon(name, options = {})
    image_tag("icons/#{name}.png", options)
  end

  # Generate the markup necessary for a required label key.
  #
  # Returns the String markup.
  def required_label
    content_tag(:div, :class => "required-label") do
      "* denotes required field"
    end
  end

  # Generate the markup necessary for a "Show Advanced Options" button.
  #
  # Returns the String markup.
  def advanced_options_button
    content_tag(:div, :style => "text-align: center;", :class=>"advanced-options-container") do
      content_tag(:span, :class => "btn") do
        link_to "Show Advanced Options", " ",
          :class => "show-advanced-options",
          :id => 'advanced-options'
      end
    end
  end

  # Prevents wrapped markup from displaying to non-Pro/Express users.
  #
  # Returns nothing.
  def licensed_content(&block)
    capture(&block) if License.get.activated?
  end

  # Displays wrapped markup for unlicensed users
  #
  # Returns nothing.
  def unlicensed_content(&block)
    capture(&block) if not License.get.activated?
  end

  # Scrub out data that can break the JSON parser
  #
  # data - The String json to be scrubbed.
  #
  # Returns the String json with invalid data removed.
  def json_data_scrub(data)
    data.to_s.gsub(/[\x00-\x1f]/){ |x| "\\x%.2x" % x.unpack("C*")[0] }
  end

  # Returns the properly escaped sEcho parameter that DataTables expects.
  def echo_data_tables
    h(params[:sEcho]).to_json.html_safe
  end

  # Converts the input string to UTF8-encoded text
  def force_utf8(data)
    data.unpack("C*").pack("C*").encode('UTF-8', **{ :invalid => :replace, :undef => :replace, :replace => '.' })
  end

  # strip javascript from page to prevent framebusting
  def strip_js(content)
    # suppress <script> tags and inline js (e.g. onclick="...")
    content.gsub(/<script.*?script>/imx, '')
           .gsub(/(<[^<^>]*?)[\s"']on\w+=["']*[^\s]+((["']\s*)|(\s*))([^<^>]*?>)/imx, '\1\5')
  end

  # nested_semantic_fields_for renders the model_instance in
  #  a normal Formtastic semantic_form, and then strips the
  #  open and close <form> tags (for valid nesting)
  # This is basically a dirty hack to emulate f.semantic_fields_for(attribtue)
  #  when your form is a tableless model.
  # @note If you're dealing with an AR model, use semantic_fields_for instead.
  def nested_semantic_fields_for(model_instance, opts={}, &blk)
    # render it like a normal, standalone Formtastic form
    form_html = semantic_form_for(model_instance, {:url => '', :authenticity_token => false}.merge(opts), &blk)
    # remove <form ..> and </form>, but keep inner content
    form_html.gsub(/<\/*form.*?>/imx, '').gsub(/^<div.*?<\/div>/imx, '').html_safe
  end

  # Helper to delete resource. Created after submit_to_remote deprecated
  def submit_delete(url, confirm_message, value = 'Delete')
    submit_tag value, name: 'delete', class: 'delete async', data: {confirm: confirm_message, url: url}
  end

end


