class SocialEngineering::HumanTarget < ApplicationRecord
  self.table_name = :se_human_targets
  
  #
  #
  # Associations - sorted by association name
  #
  #

  has_many :phishing_results, class_name: 'SocialEngineering::PhishingResult'
  has_many :trackings, class_name: 'SocialEngineering::Tracking', :dependent => :destroy
  belongs_to :user, class_name: 'Mdm::User', optional: true # another likely bug
  belongs_to :workspace, class_name: 'Mdm::Workspace', optional: true # another likely bug
  has_many :target_list_targets, class_name: 'SocialEngineering::TargetListHumanTarget'

  #
  # Has Many Through :target_list_targets
  #

  has_many :target_lists, class_name: 'SocialEngineering::TargetList', through: :target_list_targets

  #
  # Validations
  #
  
  validates :email_address,
            presence: true,
            format: { without: /\s/ },
            uniqueness: {
                scope: :workspace_id,
                case_sensitive: false
            }

  validates :workspace, :presence => true
  
  before_validation :strip_attributes

  # @return[Array] HumanTargets which have corresponding PhishingResults in the DB
  scope :phished, lambda { joins(:phishing_results) }
  scope :workspace_id, lambda { |workspace_id| where(workspace_id: workspace_id) }

  def strip_attributes
    self.attributes.each do |key, value|
      self[key] = value.strip if value.respond_to?("strip")
    end
  end

  # returns array containing [@email,@first_name,@last_name]
  def build_csv_row
    [email_address, first_name, last_name]
  end

  # Destroys all arguments that are not currently part of a TargetList. Be sure
  # to call this after deleting a TargetList or TargetListHumanTargets. Due to
  # performance reasons, orphan-ness cannot be checked via AR callbacks, and we
  # must have specific targets to check.
  def self.destroy_orphans(ids)
    SocialEngineering::HumanTarget.
      where(:id => ids).
      where.not(:id => SocialEngineering::TargetListHumanTarget.
        select(:human_target_id).distinct.
          where(:human_target_id => ids)).
      destroy_all
  end

  # returns a dummy human target with default values for name & email
  # used by se/emails_controller#preview
  def self.dummy
    target = SocialEngineering::HumanTarget.new
    target.email_address = 'example@example.com'
    target.first_name = 'John'
    target.last_name  = 'Doe'
    target.id = 0
    target
  end

  def name
    "#{last_name}, #{first_name}"
  end
  
end
