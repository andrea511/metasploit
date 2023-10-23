module Mdm::Session::Files
  def list_files(path=nil)
    c = Pro::Client.get

    if path.nil?
      # list root dirs
      roots = c.call('pro.meterpreter_root_paths', local_id)['paths']
      if roots and roots.length == 1
        return list_files(roots.first)
      else
        entries = {}
        roots.each do |root|
          entries[root] = {
              'mode' => '',
              'size' => 0,
              'type' => 'dir',
              'mtime' => 0
          }
        end
        return entries
      end
    end

    # list dir content
    entries = c.call('pro.meterpreter_list', local_id, path)['entries']
    if not entries.index('..')
      entries['..'] = {
          'mode' => '',
          'size' => 0,
          'type' => 'dir',
          'mtime' => 0
      }
    end

    return entries
  end

  def supports_files?
    ['meterpreter'].include? stype
  end
end