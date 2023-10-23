class AddNameToApiKey < ActiveRecord::Migration[4.2]
  def self.up
    add_column :api_keys, :name, :string

    execute <<-SQL
      update api_keys
      set name = concat('Key-', id)
      where name is null or name = ''
    SQL
  end

  def self.down
    remove_column :api_keys, :name
  end

end


