class SubsetValidator < ActiveModel::EachValidator
  def check_validity!
    unless options.has_key? :of
      raise ArgumentError, 'the superset must be passed to the :of option'
    end
  end

  def validate_each(record, attribute, value)
    value_set = Set.new(value)
    superset = Set.new(options[:of])

    unless value_set.subset?(superset)
      superset_sentence = superset.sort.to_sentence

      record.errors.add(attribute, "is not a subset of #{superset_sentence}")
    end
  end
end
