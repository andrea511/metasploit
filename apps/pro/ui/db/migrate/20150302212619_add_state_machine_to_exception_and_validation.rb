class AddStateMachineToExceptionAndValidation < ActiveRecord::Migration[4.2]
  def change
    add_column :nexpose_result_exceptions, :state, :string
    add_column :nexpose_result_exceptions, :nexpose_response, :string

    add_column :nexpose_result_validations, :state, :string
    add_column :nexpose_result_validations, :nexpose_response, :string
  end
end
