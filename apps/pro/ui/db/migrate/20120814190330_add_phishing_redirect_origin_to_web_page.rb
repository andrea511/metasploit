class AddPhishingRedirectOriginToWebPage < ActiveRecord::Migration[4.2]
  def change
  	add_column :se_web_pages, :phishing_redirect_origin, :string
  end
end
