Rails.autoloaders.each do |autoloader|
  autoloader.inflector.inflect(
    "open-uri" => "OpenURI",
    "fisma" => "FISMA",
    "mm_auth" => "MM_Auth",
    "mm_domino" => "MM_Domino",
    "mm_segment" => "MM_Segment",
    "mm_pnd" => "MM_PND",
    "pci" => "PCI",
    "postgresql_adapter" => "PostgreSQLAdapter",
    "ssl_cert" => "SSLCert",
    "ssl_cert_uploader" => "SSLCertUploader",
    "owasp" => "OWASP",
    "metasploit_owasp" => "MetasploitOWASP",
    "ssh" => "SSH",
    "fisma_test" => "FISMATest",
    "pci_test" => "PCITest",
    "uri" => "URI",
    "ui" => "UI",
    "ui_server_settings" => "UIServerSettings",
    )
end
