module Mdm::Session::PivotPoint
  def active_pivot_point?
    not routes.empty?
  end

  def supports_pivot_point?
    (is_admin? and ['meterpreter'].include? stype and platform =~ /windows|java/)
  end
end