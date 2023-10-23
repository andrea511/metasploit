module BruteForce
  module Reuse
    class ValidatedCredentialPresenter < DelegateClass(Attempt)

      def as_json(opts={})
        {
          'id' => self[:id],
          'public' => self['public'],
          'private' => self['private'],
          'realm' => self['realm']
        }.as_json
      end

    end
  end
end
