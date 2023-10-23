module Mdm::Workspace::Decorator
  extend ActiveSupport::Concern

  included do
    has_many :campaigns, :class_name => 'SocialEngineering::Campaign'
    has_many :report_custom_resources, :dependent => :destroy,
             :class_name => 'ReportCustomResource'

    # Override base class's definition
    # @see https://www.pivotaltracker.com/story/show/43219917
    def creds
      Mdm::Cred.where(["hosts.workspace_id = ?", self.id]).joins(:service => :host)
    end
  end

  def active_pivots?
    unless sessions.alive.any? { |s| s.routes.size > 0 }
      tasks.where(['completed_at is NULL and module = ?', "pro/tunnel"]).exists?
    else
      true
    end
  end

  def all_vulns
    vulns + web_vulns
  end

  def nfs_exports
    notes.where(:ntype => 'nfs.exports')
  end

  def recent_events(n = 5)
    Mdm::Event.where("workspace_id = ? OR workspace_id IS NULL", self[:id]).limit(n).order("created_at DESC")
  end

  def session_events
    Mdm::SessionEvent.where(["hosts.workspace_id = ?", self.id]).
      joins({:session => :host}).
      order("session_events.created_at ASC")
  end

  def smb_shares
    notes.where(:ntype => 'smb.shares')
  end

  def tags
    Mdm::Tag.where(["hosts.workspace_id = ?", self.id]).joins(:hosts).distinct
  end

end
