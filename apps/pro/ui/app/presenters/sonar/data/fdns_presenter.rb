module Sonar
  module Data
    class FdnsPresenter < DelegateClass(Fdns)

      include ActionView::Helpers::DateHelper

      def as_json(opts={})
        super.merge!(
          'last_seen'    => time_ago_in_words(last_seen) + " ago"
        )
      end

    end
  end
end
