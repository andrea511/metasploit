module AuditHelper
  def self.compare(current, updated, filter:[], same:true)
    (current.keys + updated.keys).uniq
      .map do |k|
        if current[k] == updated[k]
          if filter.include?(k)
            v = same ? '[FILTERED]' : nil
          else
            v = same ? current[k] : nil
          end
        else
          if filter.include?(k)
            v = {old: '[FILTERED]', new: '[FILTERED]'}
          else
            v = {old: current[k], new: updated[k]}
          end
        end
        {k => v}
      end
      .reduce(:merge)
      .compact
  end

  def self.show(current, filter:[])
    return current if filter.empty?
    current
      .map { |k, v| filter.include?(k) ? {k => '[FILTERED]'} : {k => v} }
      .reduce(:merge)
  end
end
