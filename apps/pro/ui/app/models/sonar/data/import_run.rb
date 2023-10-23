class Sonar::Data::ImportRun < ApplicationRecord
  #
  # Associations
  #

  # @!attribute user
  #   The user responsible for this import
  #
  #   @return [Mdm::User]
  belongs_to :user,
             class_name: 'Mdm::User'

  # @!attribute workspace
  #   The workspace/project to which this data will be scoped
  #
  #   @return [Mdm::Workspace]
  belongs_to :workspace,
             class_name: 'Mdm::Workspace'


   # @!attribute fdnses
   #   The {Fdns} results we get from Sonar
   #
   #   @return [ActiveRecord::Relation<Sonar::Data::Fdns>]
   has_many :fdns, class_name: 'Sonar::Data::Fdns', dependent: :destroy
   
   #
   # Validations
   #
   
   validates :workspace,  presence: true

   validates :user, presence: true

   validates_numericality_of :last_seen, less_than_or_equal_to: 90, presence: true,
                             message: I18n.t('activerecord.ancestors.sonar.import_run.last_seen.less_than')
   validates_numericality_of :last_seen, greater_than_or_equal_to: 1, presence:true,
                             message: I18n.t('activerecord.ancestors.sonar.import_run.last_seen.greater_than')

   validates :domain, presence: true,
               length: { in: 1..250 }


   # Hostname regex as per RFC 1123 - http://tools.ietf.org/html/rfc1123 and
   # http://stackoverflow.com/questions/106179/regular-expression-to-match-dns-hostname-or-ip-address
   validates_format_of :domain, with: /\A(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])\Z/,
                       message: I18n.t('activerecord.ancestors.sonar.import_run.domain.valid')


  # Limits the scope of the ImportRun to the given fdns IDs
  # @param [Array<Integer>] limit_fdnss the fdnss to import
  # @return [Array<Nexpose::Data::Fdns>]
  def choose_fdnss(limit_fdnss)
    fdns.where('id NOT IN (?)', limit_fdnss).destroy_all
    fdns.to_a # maintains array in rails 5 return per signature
  end
end
