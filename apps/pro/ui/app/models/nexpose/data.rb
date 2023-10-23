module ::Nexpose::Data
  def self.table_name_prefix
    'nexpose_data_'
  end

  def self.datetime_from_nx_string(time_string)
    DateTime.strptime(time_string, '%Y%m%dT%H%M%S')
  end

end
