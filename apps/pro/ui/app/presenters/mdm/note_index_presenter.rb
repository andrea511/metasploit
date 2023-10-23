module Mdm
  class NoteIndexPresenter < DelegateClass(Note)
    include ActionView::Helpers::TextHelper
    include AbstractController::Rendering
    include ApplicationHelper
    include Mdm::AnalysisTabPresenter
    include ERB::Util
    include Rails.application.routes.url_helpers

    def as_json(opts={})
      super.merge!(
          'host.name'  => host_name_html,
          'ntype'      => note_type_html,
          'created_at' => note_created_at_html,
          'data'       => note_data_html,
      )
    end

    private

    # Generate the markup for the Mdm::Note type.
    #
    # @return [String] the markup html
    def note_type_html
      link_to(json_data_scrub(ntype), workspace_notes_path(workspace, :search => ntype))
    end

    #
    # Required to render the notes/_hash.erb template below.
    def action_name
      'index'
    end

    # Generate the markup for the Mdm::Note data.
    #
    # @return [String] the markup html
    def note_data_html
      if data.kind_of?(Hash)
        b = Thread.current[:controller].get_binding
        b.local_variable_set :hash, data

        "<div class='note-data'>#{ ERB.new(File.read(File.join(Rails.root, 'app/views/notes/_hash.erb'))).result(b) }</div><a href='' class='note-data-view'>View</a> #{json_data_scrub(truncate(data.inspect, :length => 60))}"
      else
        json_data_scrub(truncate(h(data), :length => 60))
      end
    end

    # Generate the markup for the Mdm::Note's +created_at+ date.
    #
    # @return [String] the markup html
    def note_created_at_html
      created_at.to_fs(:long)
    end

    # Generate the markup for the Mdm::Note's host_count.
    #
    # @return [String] the markup html
    def note_host_count_html
      link_to(host_count, workspace_notes_path(workspace, :search => ntype), :class => 'datatables-search')
    end
  end
end
