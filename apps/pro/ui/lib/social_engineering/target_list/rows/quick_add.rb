module SocialEngineering::TargetList::Rows::QuickAdd
  extend ActiveSupport::Concern

  included do
    #
    # Callbacks
    #

    before_save :check_and_extract_quick_add_rows, :if => :quick_add_targets_present?

    #
    # Validations
    #

    validate  :validate_quick_add_targets, :if => :quick_add_targets_present?
  end

  attr_accessor :quick_add_targets

  private

  # strip all completely blank rows
  def strip_blank_quick_add_targets
    quick_add_targets.delete_if do |key, target|
      # delete if ALL values are empty
      target.select { |k,v| v.present? }.empty?
    end
  end

  # at least one target must have a valid email address
  def validate_quick_add_targets
    strip_blank_quick_add_targets
    unless quick_add_targets.select { |k,t| t['email_address'].present? }.present?
      # only fail if there was no CSV
      errors.add(:base, "No valid targets submitted.") unless csv_targets_present?
    end
  end

  def quick_add_targets_present?
    quick_add_targets.present?
  end

  def check_and_extract_quick_add_rows
    quick_add_members = []
    # iterate through targets from quick add div
    row_cnt = 1 # rows are one-indexed, and we include the header in the count
    quick_add_targets.each do |key, row|
      if validate_row row, row_cnt, 'manually added target list'
        quick_add_members << {:email_address => row["email_address"],
                              :first_name => row["first_name"],
                              :last_name => row["last_name"]}
      end
      row_cnt += 1
    end
    # Model is unique by email. Dupes are removed blindly: last one in
    # the file wins.
    @uniq_quick_add_members = quick_add_members.index_by { |e| e[:email_address] }.values
  end
end