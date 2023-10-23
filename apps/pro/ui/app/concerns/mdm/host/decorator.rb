module Mdm::Host::Decorator
  extend ActiveSupport::Concern

  included do
    #
    # ASSOCIATIONS
    #
    has_and_belongs_to_many :nexpose_assets,
                            class_name: "::Nexpose::Data::Asset",
                            association_foreign_key: "host_id",
                            foreign_key: "nexpose_data_asset_id"

    attr_accessor   :lock_attrs
  end

  #
  # CONSTANTS
  #

  # Defines how recent "recent" is
  RECENTLY_UPDATED = 8.hours

  def os
    str = os_name
    if str
      str = str + " (#{os_flavor})" if (os_flavor and not os_flavor.empty?)
    else
      str = os_flavor
    end
    (str.nil? or str.empty?) ? 'Unknown OS' : str
  end

  def title
    name ? "#{address} - #{name}" : address
  end

  def is_vm_guest?
    !self.virtual_host.blank?
  end

  def tag_frequency
    freq = {}
    tags.each do |t|
      freq[t.to_s] = Mdm::Tag.find_by_name(t.to_s).hosts.size
    end
    freq
  end

  def tag_names
    tags.map {|t| t.name}.join(", ")
  end

  def tags_count
    tags.uniq.size
  end

  def tag_count
    tags_count
  end

  # @return [Hash] of info about a running VPN pivot through this host
  # @return nil when no VPN pivot exists
  def vpn_pivot
    tunnel_tasks = self.workspace.tasks.running.where(:module => 'pro/tunnel')
    host_sessions = self.sessions.alive.pluck(:id)
    task = tunnel_tasks.find { |t| host_sessions.include?(t.options['DS_SESSION'].to_i) }
    if task.present?
      { :task_id => task.id, :session_id => task.options['DS_SESSION'] }
    else
      nil
    end
  end

  # add_tag_by_name accepts a tag_name and either finds a previous Tag object
  # or creates a new one, and assigns it to the current host
  def add_tag_by_name(tag_name)
    tag ||= Mdm::Tag.where("tags.name = ? AND hosts.workspace_id = ?", tag_name, workspace.id).joins(:hosts).first
    unless tag.present?
      tag = Mdm::Tag.new(:name => tag_name)
      tag.save
    end
    add_tag tag
  end

  # add_tag examines a host's existing tags and,
  #   if necessary, adds the current tag
  def add_tag(tag)
    tag_exists = tags.include?(tag)
    tags << tag if tag.present? && tag.valid? && !tag_exists
    tag.errors.add :name, "has already been used" if tag_exists # note must be added manually after since valid? clears all errors
    tag
  end

  def flagged?
    notes.flagged.size > 0
  end

  def recently_updated?
    updated_at >= RECENTLY_UPDATED.ago
  end

  def clear_flags
    notes.flagged.each { |n| n.seen = true; n.save! }
  end

  def to_s
    address
  end

  def name_and_address
    if name.nil? || name.empty?
      address
    else
      "%s (%s)" % [name, address]
    end
  end

  def address_int
    if address
      Rex::Socket.addr_atoi(address)
    else
      nil
    end
  end

  def status(workspace_stats=workspace.stats)
    return 4 if workspace_stats[:loot_hosts][address]
    return 3 if workspace_stats[:sess_hosts][address]
    return 2 if workspace_stats[:pass_hosts][address]
    return 1
  end

  def screenshot
    loots.where(ltype: "host.windows.screenshot").last
  end

  def smb_shares
    notes.where(ntype: "smb.shares")
  end

  def nfs_exports
    notes.where(ntype: "nfs.exports")
  end

  def all_vulns
    ( vulns + web_sites.map{|w| w.web_vulns} ).flatten
  end

  def attribute_locked?(attr)
    n = notes.find_by_ntype("host.updated.#{attr}")
    n && n.data[:locked]
  end

  def analyze_results(opts = {})
    options = opts.clone
    # for now cache_finder is only supplied when options context is taken
    # into account and is not globally unique, in the future a consistently serialized
    # `cache_finder` object may need to be added to the cache `name`
    cache_finder = opts.delete(:cache_finder)
    if cache_finder
      Rails.cache.fetch([self, :analyze_results, cache_finder]) do
        analyze(options)
      end
    else
      Rails.cache.fetch([self, :analyze_results]) do
        analyze(options)
      end
    end
  end

  private

  def analyze(opts = {})
    c = Pro::Client.get
    options = {
      workspace: workspace.name
    }.merge(opts)
    options[:host] = address
    res = c.analyze(options)
    modules_by_name = {}
    res['host']['modules'].each do |mod|
      modules_by_name[mod['mname']] = AnalyzeResultPresenter.new(mod)
    end

    modules_by_name
  end

end

