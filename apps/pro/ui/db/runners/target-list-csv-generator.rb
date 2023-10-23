require 'csv'
require 'random_data'
require 'fileutils'

def generate_csv(row_count = 25)
  # Generates a CSV suitable as an TargetList.
  # Emails are guaranteed unique per CSV; all values are otherwise random.
  csv_path = "/tmp/se_test_data.csv"

  header_row   = %w(email_address first_name last_name)

  if File.readable? csv_path
    FileUtils.rm(csv_path)
  end
  FileUtils.touch(csv_path)

  CSV.open(csv_path, "wb", :headers => :first_row) do |csv|
    #puts "[*] Attempting creation of #{row_count}-line CSV with random data"
    csv << header_row
    emails = []
    row_count.times do
      email = Random.email
      while emails.include? email # keep out dupes
        email = Random.email
      end
      emails << email
      csv << [email, Random.firstname, Random.lastname]
    end
  end

  emails = []
  CSV.foreach(csv_path) do |row|
    emails << row[0]
  end

  if emails.uniq.size == emails.size
    #puts "[*] CSV created with no duplicates: #{csv_path}"
    return csv_path
  else
    #puts "[*] WARNING: duplicate emails detected in CSV"
    #puts "-- #{emails.uniq.size} unique emails"
    #puts "-- #{emails.size} total emails"
    return false
  end
end

generate_csv
