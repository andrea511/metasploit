class Web::TransmittedHeader < ApplicationRecord
  
  belongs_to :request,  :class_name => "Web::Request",  :foreign_key => "request_id"
  belongs_to :header,   :class_name => "Web::Header",   :foreign_key => "header_id"
end
