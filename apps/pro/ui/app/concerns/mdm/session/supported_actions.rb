module Mdm::Session::SupportedActions
  def supports_collect?
    ['shell', 'meterpreter'].include? stype
  end

  def supports_collect_other_files?
    ['meterpreter'].include? stype
  end

  def supports_search?
    (['meterpreter'].include? stype and platform =~ /windows/)
  end

  def supports_shell?
    ['shell', 'meterpreter', 'powershell'].include? stype
  end

  def supports_vnc?
    (['meterpreter'].include? stype and platform =~ /windows/)
  end

  def supports_vpn_pivot?
    (['meterpreter'].include? stype and platform =~ /windows/)
  end

  def supports_transport_change?
    (['meterpreter'].include? stype and platform =~ /windows|python/)
  end
end
