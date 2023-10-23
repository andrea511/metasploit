module Mdm::User::Decorator
  # returns an ActiveRecord::Relation that queries
  #  for workspaces accessible to a given user
  def accessible_workspaces
    if admin
      Mdm::Workspace.all
    else
      Mdm::Workspace.where(id: workspaces + owned_workspaces)
    end
  end

  def http_proxy_enabled?
    http_proxy_host.present?
  end

  def title
    if fullname.blank?
      username
    else
      "#{username} (#{fullname})"
    end
  end
end
