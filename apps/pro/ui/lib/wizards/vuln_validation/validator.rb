class Wizards::VulnValidation::Validator < Wizards::BaseValidator
  def create_project_valid?
    form.workspace.valid?
  end

  def pull_nexpose_valid?
    @nexpose_valid = (
      form.nexpose_console_id.present? and 
      (
        (form.scan? and form.nexpose_scan_task.valid?) or 
        form.nexpose_sites.present?
      )
    )
  end

  def tag_valid?
    if validate_tag?
      form.custom_tag.valid?
    else
      true
    end
  end

  def exploit_valid?
    form.exploit_task.valid?
  end

  def generate_report_valid?
    if form.report_enabled
      form.report.valid?
    else
      true
    end
  end

  # returns a Hash containing inner models and names of errors
  def errors_hash
    {
      :workspace => form.workspace.present? ? form.workspace.errors.messages : {},
      :custom_tag => validate_tag? ? form.custom_tag.errors.messages : {},
      :exploit_task => form.exploit_task.present? ? form.exploit_task.specific_error : {},
      :nexpose => nexpose_errors
    }
  end

  private

  # @return [Boolean]
  def validate_tag?
    form.tagging_enabled and form.custom_tag.present? and form.use_custom_tag
  end

  def nexpose_errors
    if instance_variable_defined?(:@nexpose_valid) and !@nexpose_valid
      if form.nexpose_console_id.blank?
        'No console selected'
      elsif form.import? and form.nexpose_sites.blank?
        'No sites selected'
      elsif form.scan?
        form.nexpose_scan_task.specific_error
      end
    else
      {}
    end
  end
end