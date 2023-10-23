class CreateWizardProcedures < ActiveRecord::Migration[4.2]
  def change
    create_table :wizard_procedures do |t|
      t.text :config_hash
      t.string :state
      t.integer :task_chain_id
      t.string :type
      t.integer :workspace_id
    end
  end
end
