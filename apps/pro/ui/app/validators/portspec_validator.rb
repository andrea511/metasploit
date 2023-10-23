class PortspecValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      ports = Rex::Socket.portspec_crack(value)
    rescue
      ports = []
    end

    if ports.length < 1
      record.errors.add attribute, "is an invalid port specification"
    end
  end
end
