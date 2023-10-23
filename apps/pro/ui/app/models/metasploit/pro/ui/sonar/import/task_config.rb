class Metasploit::Pro::UI::Sonar::Import::TaskConfig
  include ActiveModel::Validations

  #
  # Attributes
  #

  # @return [Integer] return the import run
  attr_accessor :import_run

  # @return [Array<String>] `Mdm::Tag#name`s to apply to the hosts created from
  #   the Sonar import.
  attr_accessor :tags

  # @return [Integer] `Mdm::Workspace#id` of `Mdm::Workspace` to create
  #   `Mdm:Host`s and `Mdm::Service`s from Sonar.
  attr_accessor :workspace_id

  # @return [Boolean] return whether or not we are in discovery mode.
  attr_accessor :discovery


  #
  # Validations
  #

  validates :import_run,
            presence: true
  validates :workspace,
            presence: true
  validates :workspace_id,
            presence: true

  #
  # Initialize
  #

  def initialize(import_run: nil, workspace: nil, tags: [], discovery: true)
    self.import_run = import_run
    self.tags = tags
    self.workspace_id = workspace.try(:id)
    self.discovery = discovery
  end

  #
  # Instance Methods
  #

  # @note Caller should only call {#start} if `#valid?` is `true`.
  #
  # @return [nil] if no response from {#remote_procedure_call}.
  # @return [nil] if no `'task_id'` in response
  # @return [Mdm::Task] task created by the RPC
  # @raise [ActiveRecord::RecordNotFound] if `Mdm::Task#id` cannot be found.
  def start
    response = remote_procedure_call

    if response
      task_id = response['task_id']

      if task_id
        Mdm::Task.find(task_id)
      end
    end
  end

  # Cached `Mdm::Workspace` with `Mdm::Workspace#id` of {#workspace_id}.
  #
  # @return [nil] if `workspace_id` is `nil` or no `Mdm::Workspace` has
  #   {#workspace_id} for `Mdm::Workspace#id`
  # @return [Mdm::Workspace] if `Mdm::Workspace` has {#workspace_id} for
  #   `Mdm::Workspace#id`
  def workspace
    @workspace ||= Mdm::Workspace.find_by(id: workspace_id)
  end

  # Sets {#workspace} and resets {#workspace_id} to `Mdm::Workspace#id` of
  # `workspace`.
  #
  # @param workspace [Mdm::Workspace, nil]
  # @return [void]
  def workspace=(workspace)
    @workspace = workspace
    @workspace_id = workspace.try(:id)
  end

  # Sets {#workspace_id} and invalidates cached {#workspace}.
  #
  # @param workspace_id [Integer, nil] `Mdm::Workspace#id`
  # @return [void]
  def workspace_id=(workspace_id)
    @workspace_id = workspace_id
    @workspace = nil
  end

  # `Mdm::Tag#name`s with which to tag `Mdm::Host`s
  #
  # @return [Array<String>]
  def tags
    @tags ||= []
  end

  # Sets {#tags}.
  #
  # @param [Array<String>, String, nil] if a single `String`, wraps it in an
  #   `Array`.  If `nil`, makes it an empty `Array`.
  # @return [void]
  def tags=(tags)
    @tags = Array.wrap(tags)
  end

  private

  def client
    Pro::Client.get
  end

  # @return [Hash]
  def remote_procedure_call
    if discovery
      client.start_sonar_discovery(
        'DS_IMPORT_RUN_ID' => import_run.id,
        'workspace' => workspace.name
      )
    else
      client.start_sonar_import(
        'DS_IMPORT_RUN_ID' => import_run.id,
        'workspace' => workspace.name,
        'DS_AUTOTAG_TAGS' => tags
      )
    end
  end
end