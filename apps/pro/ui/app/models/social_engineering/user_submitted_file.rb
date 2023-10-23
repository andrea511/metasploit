# wraps the CampaignFile class, gives it workspace_id and user_id
class SocialEngineering::UserSubmittedFile < SocialEngineering::CampaignFile
  #
  # Associations
  #

  belongs_to :user, :class_name => 'Mdm::User'
  belongs_to :workspace, :class_name => 'Mdm::Workspace'

  #
  # Callbacks
  #

  before_save :set_file_size

  #
  # Validations
  #

  validates :name, :presence => true, :uniqueness => {:scope => :workspace_id}
  validates :attachment, :presence => true

  def set_file_size
    self.file_size = self.attachment.size
  end
end