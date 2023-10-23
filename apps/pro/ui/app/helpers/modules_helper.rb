module ModulesHelper

  def module_type_html(m)
    case m.type
      when 'exploit'
        rank = module_star_icons(m.rank.to_i)
        stance = (m.stance == "aggressive") ? "Server" : "Client"
        ( content_tag :h3, "#{stance} Application Exploit #{rank}" ).html_safe
      when 'auxiliary'
        stance = (m.stance == "aggressive") ? "Server" : "Client"
        ( content_tag :h3, "#{stance} Application Utility" ).html_safe
      else
        ''
    end
  end

  def module_icons_html(m)
    icos = m.platform.map{ |x| os_to_icon(x) }
    icos += m.targets.map{ |x| os_to_icon(x) } if m.targets
    icos += m.actions.map{ |x| os_to_icon(x) } if m.actions

    if icos.empty?
      icos << os_to_icon(m.description)
    end

    icos.uniq!

    ("<span title='#{icos.size}'></span>" + icos.map { |path| image_tag path, :size => "19x18" }.join(' ')).html_safe
  end

  def module_star_icons(rank)
    stars  = [(rank - 100), 0].max / 100
    ( (image_tag 'icons/star.png') * stars ).html_safe
  end

  def description_to_html(desc)
    preserve_indent = false
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(render_options = {escape_html:true, hard_wrap:true}), disable_indented_code_blocks:true, fenced_code_blocks:true, no_intra_emphasis:true)

    result = desc.lines.collect do |line|

      if line.scan(/```/).size == 1
        preserve_indent = !preserve_indent
      end

      if !preserve_indent
        line.strip
      else
        line.rstrip
      end

    end
    markdown.render(result.join("\n")).html_safe
  end

  def module_notes_formatted(notes)
    result = {}
    notes.sort.each do |key, values|
      values = Array.wrap(values)
      next if values.blank?
      case key
      when "RelatedModules"
        result["Related Modules"] = values.each.collect do | value |
          link_to(value.split('/')[-1], new_module_run_path(@workspace, value), class: "module-name")
        end
      when "AKA"
        result["Also Known As"] = values
      when "SideEffects"
        result["Side Effects"] = humanize_module_note_values(values)
      when "Reliability"
        result["Reliability"] = humanize_module_note_values(values)
      when "Stability"
        result["Stability"] = humanize_module_note_values(values)
      when "NOCVE"
        result["No CVE assigned"] = values
      else
        result[key] = values
      end
    end
    result
  end

  private

  def humanize_module_note_values(values)
    values.map do |s|
      case s
      when Msf::IOC_IN_LOGS
        "Indicator of compromise in logs"
      else
        s.gsub(/-/, ' ').humanize
      end
    end
  end
end
