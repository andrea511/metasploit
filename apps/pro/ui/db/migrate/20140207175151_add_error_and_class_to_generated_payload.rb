class AddErrorAndClassToGeneratedPayload < ActiveRecord::Migration[4.2]
  def change
    add_column :generated_payloads, :generator_error, :string
    add_column :generated_payloads, :payload_class, :string
  end
end
