require "csv"

class SocialEngineering::TargetList < ApplicationRecord
  include SocialEngineering::TargetList::Rows

  self.table_name = :se_target_lists

  #
  #
  # Associations - sorted by name
  #
  #

  has_many :emails, :class_name => 'SocialEngineering::Email', :dependent => :restrict_with_exception
  has_many :target_list_targets, :class_name => 'SocialEngineering::TargetListHumanTarget', :dependent => :delete_all
  belongs_to :user, :class_name => 'Mdm::User', optional: true # another likely bug
  belongs_to :workspace, :class_name => 'Mdm::Workspace', optional: true # another likely bug

  #
  # Through :target_list_targets
  #

  has_many :human_targets, :class_name => 'SocialEngineering::HumanTarget', :through => :target_list_targets

  #
  # Scopes
  #

  scope :for_workspace, lambda { |workspace| where(:workspace_id => workspace.id) }
  scope :workspace_id, lambda { |workspace_id| where(:workspace_id => workspace_id) }

  #
  # Validations
  #

  validates :name, :presence => true, :uniqueness => { :scope => :workspace_id }
  validates :user, :presence => true
  validates :workspace, :presence => true
end
