class BoundaryValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    workspace = record.workspace

    unless workspace
      record.errors.add(:workspace, "must be present to validate #{attribute} is within boundary")
    else
      unless record.workspace.allow_actions_on?(value)
        record.errors.add(attribute, 'must be inside workspace boundaries')
      end
    end
  end
end
