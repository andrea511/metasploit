class RunStat < ApplicationRecord
  belongs_to :task,  :class_name => 'Mdm::Task', :foreign_key => 'task_id'
  #validates :name, :presence => true
  #validates :data, :presence => true

end
