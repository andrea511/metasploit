module Presenters::Host
  def host_status_text(host)
    @stats ||= host.workspace.stats
    case host.status(@stats)
      when 4
        "looted"
      when 3
        "shelled"
      when 2
        "cracked"
      else
        "scanned"
    end
  end
end