class AddWrapStringFunc < ActiveRecord::Migration[4.2]
  def up
    sql_code = <<-SQL
CREATE OR REPLACE FUNCTION wrap_string(orig_text IN varchar) RETURNS VARCHAR
as $$
DECLARE
    -- Max width of each line before wrap
    max_chunk_length  INTEGER := 50;
    wrapped_array     VARCHAR[] := '{}';
    wrapped_string    VARCHAR;
    orig_length       INTEGER;
    chunk             VARCHAR;
    iIndex            INTEGER;
    iPos              INTEGER;
BEGIN
  orig_length := LENGTH(orig_text);

  IF (orig_length <= max_chunk_length) THEN
    -- The string can be returned as-is
    wrapped_string := orig_text;
  ELSE
    -- The string needs to be sliced into chunks of lengths of max_chunk_length
    iPos := 1;
    iIndex := 0;
    WHILE iPos <= orig_length LOOP
      iIndex := iIndex + 1;
      chunk := substring(orig_text, iPos, max_chunk_length);
      -- Each chunk is added into an array
      wrapped_array := array_append(wrapped_array, chunk);
      iPos := iPos + max_chunk_length;
    END LOOP;
      -- Combine array into final wrapped string
      -- Line break is used in JasperReport field with HTML styling
      -- to enforce width:
      wrapped_string := array_to_string(wrapped_array, '<br>');
  END IF;

  RETURN wrapped_string;
END $$ VOLATILE LANGUAGE plpgsql;
    SQL
    ApplicationRecord.connection.execute(sql_code)
  end

  def down
    ApplicationRecord.connection.execute("DROP PROCEDURE IF EXISTS wrap_string")
  end
end
