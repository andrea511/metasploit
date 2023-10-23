#
# Adds the #presenter column to Mdm::Tasks, which is used to look up
# a Rails presenter for serving data to a nice looking findings page.
#

class AddPresenterToMdmTasks < ActiveRecord::Migration[4.2]
  def change
    add_column :tasks, :presenter, :string
  end
end
