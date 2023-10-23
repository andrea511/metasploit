class ChangeSinglePasswordMmName < ActiveRecord::Migration[4.2]
  class Apps::App < ApplicationRecord; end

  def up
    single_password = Apps::App.where(name: 'Single Password Testing').first
    if single_password
      single_password.update_attribute(:name, 'Single Credentials Testing')
    end
  end

  def down
  end
end
