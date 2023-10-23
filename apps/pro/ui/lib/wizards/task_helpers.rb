module Wizards
  module TaskHelpers
    # mostly yanked from tasks_shared_controller_methods#process_import
    def write_file_param_to_quickfile(file_param)
      temp = nil
      path = nil
      if file_param.present?
        # Write the uploaded file to a tempfile
        temp = ::Rex::Quickfile.new('import')
        uploaded_io = file_param
        begin
          while (buff = uploaded_io.read(1024*64))
            temp.write(buff)
          end
        rescue ::EOFError
        end
        temp.flush
      else
        temp = nil
      end
      temp ? temp.path : nil
    end
  end
end