module Metasploit::Pro::Report::Type

  module Base
    # Provides shared FS locations to individual type modules
    def locations
      @_locations ||= Object.new.extend(Msf::Pro::Locations)
    end
    module_function :locations
  end

  #
  # Convenience function, for all allowed standard report types,
  # return their important attributes in a friendly chunk of text.
  #
  def standard_reports_summary
    summary = ''
    Report::VALID_TYPES.each_with_index do |x, idx|
      t = Report::REPORT_TYPE_MAP[x]
      summary << "\n--- #{idx + 1}) #{t.name} Report:\n"
      req_string = t.required_data.join(', ')
      summary << "* Required data: #{req_string.empty? ? 'None' : req_string}\n"
      summary << "* File formats: #{t.formats.join(', ').upcase}\n"
      summary << "* Options: #{t.options.join(', ')}\n"
      summary << "* Available sections: #{t.sections.values.join(', ')}\n"
      summary << "* Report directory: #{t.report_dir}\n"
      summary << "* Parent template file: #{t.template_file}\n"
    end
    puts summary
  end
  module_function :standard_reports_summary

end
