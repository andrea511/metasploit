class AddSymbolToApps < ActiveRecord::Migration[4.2]
  def change
    add_column :apps, :symbol, :string
  end
end
