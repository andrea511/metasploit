module WizardsHelper
  # Lists all report types available after a quick pentest scan.
  # Depends on the report_types helper from reports_helper.rb,
  #  so make sure you `helper ReportsHelper` in your controller
  def report_types_for_quick_pentest
    Wizards::QuickPentest::Form::QUICK_PENTEST_REPORT_TYPES
  end

  # Report types available after a quick webapp scan.
  def report_types_for_quick_web_app_scan
    Wizards::QuickWebAppScan::Form::QUICK_WEB_APP_SCAN_REPORT_TYPES
  end

  # Report types available after a VV wizard run
  def report_types_for_vuln_validation
    Wizards::VulnValidation::Form::VULN_VALIDATION_REPORT_TYPES
  end

  def auth_types_collection_for_web_app_scan
    auth_types = Wizards::QuickWebAppScan::Form::QUICK_WEB_APP_SCAN_AUTH_TYPES
    auth_types.map {|a| a.to_s.humanize }.zip(auth_types)
  end

  def scan_types_collection_for_web_app_scan
    auth_types = Wizards::QuickWebAppScan::Form::QUICK_WEB_APP_SCAN_TYPES
    auth_types.map {|a| a.to_s.humanize }.zip(auth_types)
  end

  # 
  # Helpers for building the MetaModule displays
  #

  def form_tab(name, opts={}, &blk)
    opts.merge!({ :class => "page #{name.underscore.gsub(' ', '_')} #{opts[:class]||''}" })
    content_tag(:div, opts, &blk)
  end

  def advanced_area(name, opts={}, &blk)
    opts[:display] = 'block' if opts.delete(:show)
    opts[:display] ||= 'none'
    style = opts.each_with_object("") { |k, s| s << "#{k[0]}:#{k[1]};" }
    opts.merge!(:class => "advanced #{name.to_s.underscore.gsub(' ', '_')}")
    opts.merge!(:style => style)
    content_tag(:div, opts, &blk)
  end

  def advanced_link(name, opts={})
    content = opts.fetch(:content, 'Advanced')
    opts.merge!('data-toggle-selector' => ".#{name.underscore.gsub(' ', '_')}", 'class' => 'advanced')
    link_to content, '#', opts
  end

  def wizard_form_for(form, opts={}, &blk)
    opts.merge!({ :url => wizard_path, :as => :form })
    multi_step_form_for(form, opts, &blk)
  end

  def meta_module_form_for(form, opts={}, &blk)
    opts.merge!({ :url => wizard_path, :as => :task_config, :authenticity_token => false })
    multi_step_form_for(form, opts, &blk)
  end

  def multi_step_form_for(form, opts={}, &blk)
    steps_json = @steps.map { |s| [s, wizard_path(s)] }.to_json
    extra_html(form, steps_json, opts, &blk)
  end

  def metamodule_wizard_form_for(form, opts={}, &blk)
    opts.merge!({ :url => metamodule_wizard_path(:step=>:configure_scan, :engine=>opts[:engine]), :as => :task_config, :authenticity_token => false })
    steps_json = @steps.map { |s| [s, metamodule_wizard_path(:step=>s, :engine=>opts[:engine])] }.to_json
    extra_html(form, steps_json, opts, &blk)
  end

  def extra_html(form, steps_json, opts={}, &blk)
    if opts.key?(:authenticity_token) && !opts[:authenticity_token]
      add_csrf = %Q|<input type="hidden" name="authenticity_token" value='#{form_authenticity_token.to_s}' />|
    end
    extra_html = %Q|
      <input type='hidden' name='_method' value='PUT' />
      <input type='hidden' name="workspace_id" value='#{@workspace.id}' />
      <input type='hidden' name='no_files' value='' />
      <meta name='steps' content="#{h steps_json}" />
      #{add_csrf}
    |
    semantic_form_for(form, opts, &blk).sub(/>/, '>'+extra_html).html_safe
  end


  #Rspec Environment doesn't know what to do with wizard_path
  def metamodule_wizard_path(options={})
    "/workspaces/#{@workspace.id}/apps/#{options[:engine]}/task_config/#{options[:step]}"
  end


  def nested_wizard_fields_for(form, opts={}, &blk)
    nested_semantic_fields_for(form, opts, &blk)
  end

  def tab_title(content)
    content_tag(:h4, content)
  end
end
