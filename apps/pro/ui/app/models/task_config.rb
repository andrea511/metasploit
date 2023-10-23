class TaskConfig < Custom::FormtasticFauxModel
  include Metasploit::Pro::AttrAccessor::Addresses
  include Metasploit::Pro::AttrAccessor::Boolean
  include Metasploit::Pro::IpRangeValidation
  include TaskConfig::Associations


  attr :username
  attr_reader :client

  attr_accessor :autotag_tags, :autotag_tags_new
  # @attr [Boolean] report_enabled user wants to generate a report
  attr_accessor :report_enabled

  has_one :workspace, class: Mdm::Workspace
  has_one :report

  # Convenience method to strip 'DS' from MSF datastore options hashes
  # @param[Hash] the original hash to change
  # @return[Hash] a copy of original_hash, stripping 'DS_' from any keys with it prepended
  def self.hash_with_ds_stripped_from_keys(orig_hash)
    orig_hash.keys.inject({}) do |hash, orig_key|
      new_key       = orig_key.sub(/^DS_/, '')
      hash[new_key] = orig_hash[orig_key]
      hash
    end
  end

  def self.types
    {
    :address_string    => :text,
    :blacklist_string  => :text,
    :initial_nmap      => :boolean,
    :fast_detect       => :boolean,
    :portscan_speed    => :select,
    :udp_probes        => :boolean,
    :snmp_scan         => :boolean,
    :h323_scan         => :boolean,
    :finger_users      => :boolean,
    :identify_services => :boolean,
    :single_scan       => :boolean,
    :dry_run           => :boolean
    }
  end

  def initialize(attributes)
    @client = Pro::Client.get
    @saved_attributes = attributes.dup

    if attributes[:workspace]
      self.workspace = attributes[:workspace]
    end

    if attributes[:workspace_id]
      self.workspace_id = attributes[:workspace_id]
    end

    if attributes[:autotag_tags]
      @autotag_tags = create_list_of_tag_names(attributes[:autotag_tags],attributes[:autotag_tags_new])
    end

    @report_enabled = set_default_boolean(@report_enabled, true)
    @username = attributes[:username]
  end

  # Returns a space-delimited list of tag names based on passed in IDs and
  # an optional new tag (which is used when a tag id is negative)
  def create_list_of_tag_names(tag_ids,new_tag)
    tag_names = []
    tag_ids.each do |id|
      if id.to_i > 0
        # Assumes existing names are ok, but not that they actually exist.
        tag_names << (Mdm::Tag.find_by_id(id).name rescue nil)
      else
        # TODO: allow multiple tags
        # TODO: tag name validation ought to happen elsewhere but this will do.
        sanitized_tag = new_tag.to_s.strip.lstrip.gsub(/^#+/,"").gsub(/[^A-Za-z0-9_\x2d\x2e]+/,"_")
        tag_names << sanitized_tag if sanitized_tag =~ /[A-Za-z0-9]/
      end
    end
    tag_names.reject {|t| t.nil? || t.empty?}.join(" ")
  end

  def start
    return nil unless valid?
    res = rpc_call()
    return nil unless res
    @id = res['task_id']
    return nil unless @id
    task = Mdm::Task.find(@id)

    # Save the serialized attributes so we can rerun this task at a later date
    if allows_replay?
      task.settings = @saved_attributes.dup.permit!.merge(:task_type => self.class.to_s).to_h
      task.save
    end

    task
  end

  # Must be overridden by subclasses.  This method will be called after
  # successful validation
  def rpc_call(client)
    raise
  end

  # Must be overridden to enable replayable tasks
  def allows_replay?
    false
  end

  # May be overridden to perform additional validation before the rpc_call
  # is invoked
  def valid?
    true
  end

  # Returns the error message from the previous call to valid?()
  def error
    @error || "Task failed to start"
  end

  # Returns the raw error message ivar, without a fallback
  def specific_error
    @error
  end

  # id method is required in order to use form_for with non-ActiveRecord objects
  def id
    nil
  end

  def current_profile
    Mdm::Profile.find_by_active(true)
  end
end
