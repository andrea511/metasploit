class AddNotNulltoReportState < ActiveRecord::Migration[4.2]
  def change
    change_column_null :reports, :state, false
    change_column_default :reports, :state, 'unverified'
  end
end
