class CredentialsFileValidator < ActiveModel::EachValidator
  include ActionView::Helpers::NumberHelper

  #
  # CONSTANTS
  #

  MAX_SIZE = 1.megabyte

  #
  # Methods
  #

  def validate_each(record, attribute, value)
    if value.present? and File.exist? value
      if File.readable? value
        size = File.size(value)

        if size.zero?
          record.errors.add(attribute, 'is empty')
        elsif size > MAX_SIZE
          human_size = number_to_human_size(MAX_SIZE)
          record.errors.add(attribute, "too large (over #{human_size})")
        else
          data = ''

          File.open(value, 'rb') do |f|
            # pass file size so it reads file in one block.  Faster on Windows by limiting context switches.
            data = f.read(f.stat.size)
          end

          unless data.include? "\n"
            record.errors.add(attribute, 'is not newline delimited')
          end
        end
      else
        record.errors.add(attribute, 'not readable')
      end
    else
      record.errors.add(attribute, 'not found')
    end
  end
end
