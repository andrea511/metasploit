class Web::RequestGroup < ApplicationRecord
  include Web::RequestGroup::Cookies
  
  #
  # Associations
  #

  # @!attribute [rw] headers
  #   @return [Array<Web::Header>] headers sent with this request, not including the Cookie header, which is broken out
  #     into individual #cookies.
  has_many :headers,
           -> { order(:position) },
           :class_name => 'Web::Header',
           :dependent => :destroy,
           :foreign_key => :request_group_id

  has_many :requests, :class_name => "Web::Request", :foreign_key => :request_group_id
  
  # @!attribute [rw] user
  #   @return [Mdm::User] the user that either manually made this request or started the automated request process.
  belongs_to :user, :class_name => 'Mdm::User'

  # @!attribute [rw] workspace
  #   @return [Mdm::Workspace]
  belongs_to :workspace, :class_name => 'Mdm::Workspace'

  validates :user, :presence => true
  validates :workspace, :presence => true
  validates :workspace,
            :usable => {
                :by => :user
            }


  # This section needed for HTML::Rewrite and NadaProxy

  def find_request(uri, method)
    converted_uri = Web::URI.convert(uri)
    self.requests.
      joins(:virtual_host).
      where(:web_virtual_hosts => {:name => converted_uri.host}, 
            :path => converted_uri.path, :method => method).first
  end

  def find_or_create_request(uri, method)
    converted_uri = Web::URI.convert(uri)
    if request = find_request(uri, method)
      request
    else
      request = Web::Request.create_by_uri!(converted_uri, :workspace_id => workspace.id, :method => method)
      self.requests << request
      request
    end    
  end

end
