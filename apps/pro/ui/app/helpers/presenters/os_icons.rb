module Presenters::OsIcons
  def module_icons(platform_names,target_names,action_names)
    icos = platform_names.map{|x| os_to_icon(x) }
    icos += target_names.map{ |x| os_to_icon(x) } if target_names
    icos += action_names.map{ |x| os_to_icon(x) } if action_names

    if icos.empty?
      icos << os_to_icon(description)
    end

    icos.uniq!
    icos
  end

  def os_to_icon(str)
    ico = case str.to_s.downcase
            when /vmware/
              'vm-logo'
            when /aix/
              'aix-logo'
            when /apple|osx|os x|macintosh/
              'apple-logo'
            when /beos/
              'beos-logo'
            when /openbsd/
              'openbsd-logo'
            when /freebsd/
              'freebsd-logo'
            when /bsd/
              'bsd-logo'
            when /cisco/
              'cisco-logo'
            when /hpux|hp300|hp-ux/
              'hp-logo'
            when /ibm/
              'ibm-logo'
            when /linux|debian|ubuntu|redhat|suse/
              'linux-logo'
            when /print/
              'printer-logo'
            when /route/
              'router-logo'
            when /solaris/
              'solaris-logo'
            when /sunos/
              'sunos-logo'
            when /windows/
              'win-logo'
            else
              'unknown-logo'
          end
  end
end