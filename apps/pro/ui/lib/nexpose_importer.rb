class NexposeImporter
  def initialize(opts={})
    @console = opts[:console]
    @current_user = opts[:current_user]
    @workspace = opts[:workspace]
  end

  def run
    @import_run = ::Nexpose::Data::ImportRun.create(
        :console => @console,
        :user => @current_user,
        :workspace => @workspace
    )

    @import_run.delay.start! # run asynchronously
    @import_run
  end

end