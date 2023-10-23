class SocialEngineering::EmailTemplate < ApplicationRecord
  CONTENT_VALIDATION_REGEX = /{{\s{,1}email_content\s{,1}}}/
  LIQUID_DROP_PAIRS = { 'Email Content' => '{{email_content}}', 
                        'Email Address' => '{{email_address}}', 
                        'First Name' => '{{first_name}}',
                        'Last Name' => '{{last_name}}' }

  self.table_name = :se_email_templates
  belongs_to :workspace, :class_name => "Mdm::Workspace"
  belongs_to :user, :class_name => "Mdm::User"
  has_many :emails, :class_name => "SocialEngineering::Email", :dependent => :restrict_with_exception

  validates :name, :presence => true, :uniqueness => {:scope => :workspace_id}
  validates :content, :presence => true,
                      :format => { :with => CONTENT_VALIDATION_REGEX,
                                   :message => " must include the {{ email_content }} tag." }
  include LiquidTemplating::Powers
  liquid_template :content

  attr_accessor :insert

  # shown in the "Insert custom attribute" dropdown
  def custom_attributes
    LIQUID_DROP_PAIRS
  end

  # @example During render for email
  #   @email = SocialEngineering::Email.find(1)
  #   @human_target = SocialEngineering::HumanTarget.find(1)
  #   email_content = @email.liquid_render_with_drop_object @human_target
  #   @email.email_template.render_with_email_content(email_content)
  def render_with_email_content(email_content, human_target=nil)
    # TODO: move parse to final process code for perf reasons

    if human_target.present?
      template = Liquid::Template.parse(content)# liquid_render_with_drop_object(human_target)
      template.render("email_content" => email_content,
        "first_name" => human_target.first_name,
        "last_name" => human_target.last_name,
        "email_address" => human_target.email_address)
    else
      template = Liquid::Template.parse(content)
      template.render("email_content" => email_content)
    end
  end
end
