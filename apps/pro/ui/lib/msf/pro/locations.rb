module Msf
###
#
# This module provides shared methods for top-level Pro modules
#
###
module Pro
module Locations

  def pro_base_directory
    ::File.expand_path(::File.join(::File.dirname(__FILE__), '..', '..', '..', '..'))
  end

  def pro_backups_directory
    ::File.expand_path(::File.join(pro_base_directory, 'backups'))
  end

  def pro_rc_scripts_directory
    ::File.expand_path(::File.join(pro_base_directory, 'rc_scripts'))
  end

  def pro_cred_files_directory
    ::File.expand_path(::File.join(pro_base_directory, 'cred_files'))
  end

  def pro_data_directory
    ::File.expand_path(::File.join(pro_base_directory, 'data'))
  end

  # TODO This looks like a mistake, not a real dir?
  def pro_logs_directory
    ::File.expand_path(::File.join(pro_base_directory, 'logs'))
  end

  def pro_log_directory
    ::File.expand_path(::File.join(pro_base_directory, 'log'))
  end

  def pro_tasks_directory
    ::File.expand_path(::File.join(pro_base_directory, 'tasks'))
  end

  def pro_ui_directory
    ::File.expand_path(::File.join(pro_base_directory, 'ui'))
  end

  def pro_ui_log_directory
    ::File.expand_path(::File.join(pro_ui_directory, 'log'))
  end

  def pro_config_directory
    ::File.expand_path(::File.join(pro_ui_directory,'config'))
  end

  def pro_database_config_path
    ::File.expand_path(::File.join(pro_config_directory,'database.yml'))
  end

  def pro_modules_directory
    ::File.expand_path(::File.join(pro_base_directory, 'modules'))
  end

  def pro_scripts_directory
    ::File.expand_path(::File.join(pro_base_directory, 'scripts'))
  end

  def pro_engine_directory
    ::File.expand_path(::File.join(pro_base_directory, 'engine'))
  end

  def pro_license_directory
    ::File.expand_path(::File.join(pro_engine_directory, 'license'))
  end

  def pro_tmp_directory
    ::File.expand_path(::File.join(pro_engine_directory, 'tmp'))
  end

  def pro_loot_directory
    ::File.expand_path(::File.join(pro_base_directory, 'loot'))
  end

  def pro_report_directory
    ::File.expand_path(::File.join(pro_base_directory, 'reports'))
  end

  def pro_report_image_directory
    ::File.expand_path(::File.join(pro_report_directory, 'images'))
  end

  def pro_report_artifact_directory
    ::File.expand_path(::File.join(pro_report_directory, 'artifacts'))
  end

  def pro_report_custom_resources_directory
    ::File.expand_path(::File.join(pro_report_directory, 'custom_resources'))
  end

  def pro_report_temp_directory
    ::File.expand_path(::File.join(pro_report_directory, 'temp'))
  end

  def pro_report_tmp_img_directory
    ::File.expand_path(::File.join(pro_report_temp_directory, 'temp_imgs'))
  end

  def pro_report_virt_directory
    ::File.expand_path(::File.join(pro_report_temp_directory, 'report_virtualization'))
  end

  def pro_export_directory
    ::File.expand_path(::File.join(pro_base_directory, 'export'))
  end

  def pro_install_directory
    ::File.expand_path(::File.join(pro_base_directory, '..', '..'))
  end

  def pro_java_directory
    ::File.expand_path(::File.join(pro_base_directory, 'java'))
  end

  def pro_john_executable
    path = ::File.join(pro_install_directory, 'john', 'bin', 'john')
    return ::File.expand_path(path) if File.exist?(path)

    path = ::File.join(pro_install_directory, 'john', 'bin', 'john.exe')
    return ::File.expand_path(path) if File.exist?(path)

    # Otherwise presume this is a local checkout
    path = ::File.join('..', 'data', 'john', 'bin', 'john')
    return ::File.expand_path(path) if File.exist?(path)

    path = ::File.join('..', 'data', 'john', 'bin', 'john.exe')
    return ::File.expand_path(path) if File.exist?(path)
  end

  # Find the java executable.
  def pro_java_executable
    path = ::File.join(pro_install_directory, 'java', 'bin', 'java')
    return ::File.expand_path(path) if File.exist?(path)

    path = ::File.join(pro_install_directory, 'java', 'bin', 'java.exe')
    return ::File.expand_path(path) if File.exist?(path)

    ret = Rex::FileUtils.find_full_path("java") || Rex::FileUtils.find_full_path("java.exe")
    return ::File.expand_path(ret) if ret
  end

  # Hunt for Nmap within the installation directory, defaulting to
  # the system version as necessary
  def pro_nmap_executable
    path = ::File.join(pro_install_directory, 'nmap', 'nmap')
    return ::File.expand_path(path) if File.exist?(path)

    path = ::File.join(pro_install_directory, 'nmap', 'nmap.exe')
    return ::File.expand_path(path) if File.exist?(path)

    path = ::File.join(pro_install_directory, 'common', 'bin', 'nmap')
    return ::File.expand_path(path) if File.exist?(path)

    path = ::File.join(pro_install_directory, 'common', 'bin', 'nmap.exe')
    return ::File.expand_path(path) if File.exist?(path)

    ret = Rex::FileUtils.find_full_path("nmap") || Rex::FileUtils.find_full_path("nmap.exe")
    return ::File.expand_path(ret) if ret
    nil
  end

  # Hunt for the Nmap data paths within the installation directory, defaulting
  # to nil if none was found. In the case of nil, do not specify the data path
  def pro_nmap_datapath
    path = ::File.join(pro_install_directory, 'nmap', 'nmap-os-db')
    return ::File.expand_path(::File.dirname(path)) if File.exist?(path)

    path = ::File.join(pro_install_directory, 'common', 'share', 'nmap', 'nmap-os-db')
    return ::File.expand_path(::File.dirname(path)) if File.exist?(path)
    nil
  end

  # Return where the exe templates are stored
  def express_exe_template_directory
    ::File.join(pro_data_directory, 'exe_templates')
  end

  def pro_exe_template_directory
    ::File.join(pro_data_directory, 'exe_templates', 'pro')
  end

end
end
end

