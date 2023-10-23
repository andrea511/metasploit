module BruteForce
  module Guess
    class AttemptPresenter < DelegateClass(Attempt)


      def as_json(opts={})
        super.merge!(
          'private_show_modal' => show_modal?,
          'private_type_humanized' => self[:private_type].demodulize,
          'full_fingerprint' => (self[:private_type].demodulize == 'SSHKey' ? Metasploit::Credential::SSHKey.new(data:self[:private]).to_s : nil)
        )
      end

      private

      def show_modal?
        self[:private_type].constantize != Metasploit::Credential::Password
      end

    end
  end
end
