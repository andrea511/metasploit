class OpenedSessionsFinder < Struct.new(:campaign)

  def find
    selects = ["sessions.id",
      "sessions.stype",
      "sessions.via_exploit",
      "sessions.desc",
      "sessions.platform",
      "sessions.opened_at",
      "hosts.name as host_name",
      "(hosts.os_name||' ' || hosts.os_flavor) as os"]
    Mdm::Session.where("campaign_id = ?", campaign.id).joins(:host).select(selects.join(','))
  end

  # fields that we want to return in the result
  def datatable_columns
    [:id, :host_name, :desc, :stype, :via_exploit, :os, :platform, :opened_at]
  end

  # fields that we want to be searchable
  def datatable_search_columns
    [:stype, :via_exploit, :"sessions.desc", :platform, :"hosts.name", :"hosts.os_name", :"hosts.os_flavor"]
  end

end
