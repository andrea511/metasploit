class UIServerSettings

  def initialize(values={})
    set_default_values(values)
  end

  def logged_in_timeout
    @values['ui_server_logged_in_timeout'].to_i
  end

  def consecutive_failed_logins_limit
    @values['ui_server_consecutive_failed_logins_limit'].to_i
  end

  def apply_to(target)
    @values.each do |key, value|
      target[key] = value
    end
  end

  private

  DEFAULT_VALUES = {
    'ui_server_logged_in_timeout'               => 30.minutes.to_i,
    'ui_server_consecutive_failed_logins_limit' => 5,
  }

  def set_default_values(initial_values)
    ui_server_values = find_ui_server_values(initial_values)
    @values = DEFAULT_VALUES.merge(ui_server_values)
  end

  def find_ui_server_values(hash)
    hash.select { |k| k.to_s.starts_with? 'ui_server' }
  end
end
