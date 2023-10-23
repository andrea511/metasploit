class AddCollapseRangesFunc < ActiveRecord::Migration[4.2]

  def up
    ApplicationRecord.connection.execute <<-SPROC
        /* Accepts integer array
           Returns string of integers passed with any consecutive integers collapsed into ranges, 
           e.g. {1,2,3,5,7} -> '1-3,5,7'
        */
        CREATE or REPLACE FUNCTION collapse_ranges(all_results int[]) 
          RETURNS text 
          LANGUAGE plpgsql STRICT
          AS $$
          DECLARE
            x int;
            last_member int;
            current_range int[];
            final_string text;
            result_size int := array_upper(all_results, 1);
            iter int := 0;
          BEGIN
            FOREACH x IN ARRAY all_results 
            LOOP
            
              if current_range is null then
                current_range := array_append(current_range, x);
              else 
                if (x = last_member + 1) then -- if it is the increment of the previous, add to range
                  current_range := array_append(current_range, x);
                else -- next element is non-consecutive
                  if array_upper(current_range,1) > 1 then -- if the previous element ended a range, add it 
                    final_string := concat(final_string, current_range[array_lower(current_range, 1)], ' - ', current_range[array_upper(current_range, 1)]);
                  else
                    final_string := concat(final_string, current_range[array_upper(current_range, 1)]);
                  end if;
                  final_string := concat(final_string, ', ');
                  current_range := '{}';
                  current_range := array_append(current_range, x);
                end if;
              end if;
              last_member := x;
              iter := iter + 1;
              if iter = result_size then -- last entry
                if array_upper(current_range,1) > 1 then -- if the previous element ended a range, add it 
                  final_string := concat(final_string, current_range[array_lower(current_range, 1)], ' - ', current_range[array_upper(current_range, 1)]);
                else
                  final_string := concat(final_string, x);
                end if;
              end if;

            END LOOP;
            return final_string;
          END;
        $$;    
    SPROC
  end

  def down
     ApplicationRecord.connection.execute "DROP FUNCTION IF EXISTS collapse_ranges(all_results int[]);"
  end
end
