module SocialEngineering::TargetList::Rows::CSV
  extend ActiveSupport::Concern

  #
  # CONSTANTS
  #

  VALID_CSV_IMPORT_FILE_HEADERS_FORMAT = [:email_address, :first_name, :last_name]

  included do
    #
    # Callbacks
    #

    before_save :check_and_extract_csv_rows, :if => :csv_targets_present?

    #
    # Validations
    #

    validate  :validate_csv_targets, :if => :csv_targets_present?
  end

  attr_accessor :import_file

  def import_filename
    File.basename(import_file)
  end

  attr_writer :import_filename

  private

  # Verifies that all rows have the email address column populated
  # with something like an email.
  # Loads rows into memory for further processing.
  def check_and_extract_csv_rows
    csv_members = []
    row_cnt = 2 # rows are one-indexed, and we include the header in the count
    begin
      CSV.foreach(import_file, :headers => true, encoding: "ISO8859-1:UTF-8") do |row|
        # Email column must be present for all rows:
        if validate_row row, row_cnt, import_filename
          csv_members << {:email_address => row["email_address"].downcase,
                          :first_name => row["first_name"],
                          :last_name => row["last_name"]}
        end
        row_cnt += 1
      end
  
      # Model is unique by email. Dupes are removed blindly: last one in
      # the file wins.
      @uniq_csv_members = csv_members.index_by{|e| e[:email_address]}.values
      
    rescue CSV::MalformedCSVError => e # ill-formatted CSV
      # Display an error to the user when there's a problem with a row
      errors.add(:base, e.to_s)
    end
  end

  # Verifies the header row has the desired format.
  def csv_headers_in_compliance?
    begin
      file = CSV.open(import_file, encoding: "ISO8859-1:UTF-8")
      if file.present?
        first_row = file.first
        if first_row.present?
          header_symbols = first_row.map do |row|
            if row.present? then row.to_sym else :blank end
          end
          return header_symbols == VALID_CSV_IMPORT_FILE_HEADERS_FORMAT
        end
      end
      false
    rescue CSV::MalformedCSVError => e # ill-formatted CSV
      false
    end
  end

  # Verifies CSV file is not blank.
  def csv_populated?
    import_file && import_file.size > 0
  end

  def csv_targets_present?
    import_file.present? && import_filename.present?
  end

  # Verifies that CSV is not empty and that it has proper header row.
  def csv_valid?
    csv_populated? && csv_headers_in_compliance?
  end

  def validate_csv_targets
    unless csv_valid?
      if !csv_populated?
        errors.add(:base, "No targets received.")
      elsif !csv_headers_in_compliance?
        errors.add(:base, "CSV must have a header and format like: #{VALID_CSV_IMPORT_FILE_HEADERS_FORMAT.map(&:to_s).join(",")}")
      end
    end
  end
end
