module Mdm::Workspace::Authorization
  # true if this workspace's settings can be changed by the given user
  def manageable_by?(user)
    if License.get.multi_user?
      user and (user.admin? or user == owner)
    else
      true
    end
  end

  def usable_by?(user)
    if License.get.multi_user?
      manageable_by?(user) or users.include?(user)
    else
      true
    end
  end
end