module Mdm::Module::Detail::Associations
  extend ActiveSupport::Concern

  included do
    has_many :nexpose_data_exploits,
             class_name:  'Nexpose::Data::Exploit',
             foreign_key: 'source_key',
             primary_key: 'fullname',
             inverse_of:  :module_detail
  end
end