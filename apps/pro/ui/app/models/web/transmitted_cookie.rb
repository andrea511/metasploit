class Web::TransmittedCookie < ApplicationRecord
    
  belongs_to :request,  :class_name => "Web::Request",  :foreign_key => "request_id"
  belongs_to :cookie,   :class_name => "Web::Cookie",   :foreign_key => "cookie_id"
end
