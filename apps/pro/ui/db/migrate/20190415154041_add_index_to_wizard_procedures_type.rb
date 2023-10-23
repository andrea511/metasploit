class AddIndexToWizardProceduresType < ActiveRecord::Migration[4.2]
  def change
    add_index :wizard_procedures, :type
  end
end
