class AddUserIdToWizardProcedures < ActiveRecord::Migration[4.2]
  def change
    add_column :wizard_procedures, :user_id, :integer
  end
end
