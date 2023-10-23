class SocialEngineering::WebTemplate < ApplicationRecord
  ORIGIN_TYPES = ['custom', 'clone']
  CONTENT_VALIDATION_REGEX = /{{\s{,1}web_page_content\s{,1}}}/
  LIQUID_DROP_PAIRS = { 'Web Page Content' => '{{web_page_content}}' }

  self.table_name = :se_web_templates
  belongs_to :workspace, :class_name => "Mdm::Workspace"
  belongs_to :user, :class_name => "Mdm::User"
  validates :origin_type, :inclusion => { :in => ORIGIN_TYPES }
  validates :name, :presence => true, :uniqueness => {:scope => :workspace_id}
  validates :content, :presence => true,
                         :format => { :with => CONTENT_VALIDATION_REGEX,
                                      :message => " must include the {{ web_page_content }} tag." }
  has_many :web_pages, 
           :foreign_key => 'template_id',
           :class_name => "SocialEngineering::WebPage", 
           :dependent => :restrict_with_exception
  after_initialize :populate_content
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
  def render_with_web_page(web_page)
    # TODO: move parse to final process code for perf reasons
    template = Liquid::Template.parse(content)
    template.render("web_page_content" => web_page.content)
  end


  private
    def populate_content
      self.content ||= <<-eos
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <title>Metasploit Pro Social Engineering Web Page</title>
</head>
<body>
  <!-- the Web Page Content gets inserted below -->
  {{ web_page_content }}
</body>
</html>
eos
    end
end
