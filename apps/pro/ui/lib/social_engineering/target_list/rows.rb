module SocialEngineering::TargetList::Rows
  extend ActiveSupport::Concern

  include SocialEngineering::TargetList::Rows::CSV
  include SocialEngineering::TargetList::Rows::QuickAdd

  included do
    #
    # Callbacks
    #

    before_save :process_rows, :if => :any_targets_present?
  end

  private

  def any_targets_present?
    csv_targets_present? || quick_add_targets_present?
  end

  # Pulls out email addresses from extracted list,
  # searches for matches amongst current HTs.
  # In the case of a match: only add join table entry.
  # Otherwise, add HT as usual, along with join table entry.
  def process_rows
    # combine csv_uniq_quick_add and csv_uniq_csv members
    @uniq_quick_add_members ||= []
    @uniq_csv_members ||= []

    uniq_members = (@uniq_quick_add_members + @uniq_csv_members).collect{|h| h.merge(email_address: h[:email_address].strip) }.uniq{|m| m[:email_address] }

    # fail here if there are NO rows to process
    if uniq_members.empty?
      errors.add(:base, "No valid human targets to add.")
      return false
    end

    uniq_members.each do |member|
      begin
        human_target = SocialEngineering::HumanTarget.where(
            :workspace_id => self.workspace.id
        ).where(
            # Model constraint is case insensitive
            'TRIM(LOWER(email_address)) = ?', [member[:email_address]],
        ).first_or_create!(email_address: member[:email_address], first_name: member[:first_name], last_name: member[:last_name])
      rescue => e
        errors.add(:base, "Could not create Human Target. #{e}")
        return false
      end

      # The create is only called if the address does not exists, however the uniqueness check
      # is based on the email address, so the original is not updated
      if human_target.first_name.downcase != member[:first_name].downcase || human_target.last_name.downcase != member[:last_name].downcase
        error_msg =    "#{member[:email_address]} for #{member[:first_name]} #{member[:last_name]} is already assigned:\n"
        error_msg +=   "#{human_target.email_address} - #{human_target.first_name} #{human_target.last_name} exists in the following target lists:\n"
        human_target.target_lists.each do |target_list|
          error_msg += "\t#{target_list.name}\n"
        end
        errors.add(:base, error_msg)
        return false
      end

      unless human_target.valid?
        errors.add(:base, 'Invalid human target.')
        return false
      end

      candidate = self.target_list_targets.build(
          :target_list_id => self.id,
          :human_target_id => human_target.id
        )
      self.target_list_targets.delete(candidate) unless candidate.valid?
    end
  end

  def validate_row(row, row_cnt=0, filename='')
    # and empty row does not validate however it is also not an error.
    return false if row["email_address"].nil? && row["first_name"].nil? && row["last_name"].nil?
    # Email must be somewhat recognizable as an email:
    email = row["email_address"]
    email_pat = /.+@.+\..+/
    email_valid = (email =~ email_pat) == 0 ? true : false

    if not email or email == ''
      errors.add(:base, "Error: Undefined email address for human target at row #{row_cnt} in #{filename}.")
    elsif not email_valid
      errors.add(:base, "Error: Email address not properly formatted at row #{row_cnt} in #{filename}.")
    else
      return true
    end
    false
  end
end
