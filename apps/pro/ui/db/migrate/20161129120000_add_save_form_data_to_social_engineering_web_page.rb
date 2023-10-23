class AddSaveFormDataToSocialEngineeringWebPage < ActiveRecord::Migration[4.2]
  def change
    add_column :se_web_pages, :save_form_data, :boolean, default: true
    add_column :se_web_pages, :original_content, :string
  end
end
