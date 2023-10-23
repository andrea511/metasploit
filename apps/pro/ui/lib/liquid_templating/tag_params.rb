# Simple way to get parameterized values from single string passed in to a custom Liquid tag


class LiquidTemplating::TagParams
  class InvalidInputString < Exception; end
  class InvalidTagFormat < Exception; end
  attr_reader :params_list

  def initialize(params_string)
    @params_list = []
    begin
      temp_list = CSV.parse(params_string.rstrip, :quote_char => "'").flatten
      temp_list.each do |ele| 
          param = ele.strip
          params_list << param
      end
    rescue CSV::MalformedCSVError
      raise InvalidTagFormat, "invalid tag parameter string '#{params_string}'"
    end
  end

  def self.parse(params_string, min_num_params_expected=-1)
    params = new(params_string).params_list
    if min_num_params_expected > -1 && params.size < min_num_params_expected
      raise InvalidTagFormat, "invalid tag format: At least #{min_num_params_expected} argument(s) expected"
    end
    params
  end

end
