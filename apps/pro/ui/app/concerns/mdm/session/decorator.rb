module Mdm::Session::Decorator
  def is_admin?
    return true
  end

  def to_s
    s = "Session #{id}"
    s << " - #{host.address}" if host
    s << " (#{desc})" unless desc.blank?
    s
  end
end

