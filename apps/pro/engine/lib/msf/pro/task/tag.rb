
module Msf
###
#
# This module provides shared methods for top-level Pro modules
#
###
module Pro
module Task
module Tag

  # Takes an array of hosts and a string (space-delimited by default) of tag names,
  # and applies all the supplied tags to the hosts (technically, adds
  # the hosts to those tags).
  #
  # Generally, autotagging should(?) fail silently rather than raise an
  # error.

  def autotag_hosts(hosts,taglist, regex=/\s+/)

    ::ApplicationRecord.connection_pool.with_connection {
      return unless hosts.respond_to? :each
      return unless taglist.respond_to? :split
      hosts.each do |host|
        if host.kind_of?(::Mdm::Host)
          this_host = host
        else
          this_host = myworkspace.hosts.find_by_address(host)
        end
          next unless host
        taglist.split(regex).each do |tagname|
          tag = find_or_create_host_tag(tagname)
          next if tag.hosts.include?(this_host)
          tag.hosts ||= []
          tag.hosts << this_host unless tag.hosts.include? this_host

          if tag.changed?
            tag.save
            taglist_formatted = taglist.split(regex).map {|t| "##{t}"}.join(", ")
            print_status "Tagging %s with %s" % [this_host.address, taglist_formatted]
          end

          tag.save if tag.changed?
        end
      end
    }
  end

  # Shorthand for autotagging single host.
  def autotag_host(host,taglist)
    autotag_hosts([host],taglist)
  end

  def find_or_create_host_tag(tagname)
    ::ApplicationRecord.connection_pool.with_connection {
      possible_tag = myworkspace.host_tags.select {|t| t.name == tagname}.first
      tag = possible_tag || ::Mdm::Tag.new
      tag.name = tagname
      return tag
    }
  end

  def autotag_os(host)
    return unless host && host.kind_of?(::Mdm::Host)
    tagname = "os_#{detect_os(host)}"
    ::ApplicationRecord.connection_pool.with_connection {
      tag = find_or_create_os_tag(tagname)
      return tag if tag.hosts.include?(host)
      clear_host_os_tags(host) # Prevent multiple os tags
      tag.hosts ||= []
      tag.hosts << host unless tag.hosts.include? host
      tag.save if tag.changed?
      return tag
    }

  end

  def clear_host_os_tags(host)
    ::ApplicationRecord.connection_pool.with_connection {
      host.tags.each do |tag|
        next unless possible_os_autotags().include?(tag.name)
        tag.hosts.delete(host)
        tag.save
      end
      return host
    }
  end

  # This is unique to just OS labels.
  def find_or_create_os_tag(tagname)
    ::ApplicationRecord.connection_pool.with_connection {
      possible_tag = myworkspace.host_tags.select {|t| t.name == tagname}.first
      tag = possible_tag || ::Mdm::Tag.new
      tag.name = tagname

      # Come up with some kind of automatic description?
      # tag.desc = "Automatically tagged" # Pretty redundant
      return tag
    }
  end

  def possible_os_autotags
    [:aix, :apple, :beos, :openbsd, :freebsd, :bsd,
      :cisco, :hp, :ibm, :linux, :printer, :router,
      :solaris, :sunos, :windows, :unknown].map {|x| "os_#{x}"}
  end

end
end
end
end
