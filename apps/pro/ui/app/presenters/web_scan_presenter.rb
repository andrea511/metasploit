#
# Presents information on the currently running WebScan task,
# pulling model objects from the DB which are created during
# either the WebScan or WebAudit tasks.
#
# WebScanTask and WebAuditTask are referred to collectively as "WebScan"
#
# Only certain classes need to be in the stats that we collect for scans
# Thankfully, they all have very similar DB connections:
# Each connects to Mdm::WebSite, which connects to Service --> Host --> Workspace.
# We can therefore generate methods to do the common finds.
#
class WebScanPresenter
  attr_reader :task

  # Create finder methods.  Conveniently enough, these all correspond to table names:
  DB_STAT_CLASSES = [Mdm::WebPage, Mdm::WebForm, Mdm::WebVuln]
  DB_STAT_CLASSES.each do |stat_class|
    define_method(stat_class.table_name) do
      selects = ["#{stat_class.table_name}.id", "#{stat_class.table_name}.created_at"]
      results = stat_class.select(selects.join(','))
        .joins(web_object_join_sql(stat_class.table_name))
        .where("workspaces.id = ? AND #{stat_class.table_name}.created_at > ?", task.workspace.id, task.created_at)
      if stat_class == Mdm::WebPage
        results = results.where("code < 400")
      end
      results
    end
  end

  # The task that is currently being shown in the UI
  def initialize(task)
    @task = task
  end

  def to_json
    [:web_pages, :web_forms, :web_vulns].inject({}) { |hash, web_datum_type|
      hash[web_datum_type] = {
        display: web_datum_type.to_s.humanize,
        value: self.send(web_datum_type).size
      }
      hash
    }.to_json
  end

  private

  # Joins common to all WebObjects
  def web_object_join_sql(root_table)
    <<-eoq
      INNER JOIN web_sites ON #{root_table}.web_site_id = web_sites.id
      INNER JOIN services on web_sites.service_id = services.id
      INNER JOIN hosts on services.host_id = hosts.id
      INNER JOIN workspaces on hosts.workspace_id = workspaces.id
    eoq
   end
end