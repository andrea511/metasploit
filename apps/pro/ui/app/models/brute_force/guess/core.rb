class BruteForce::Guess::Core < ApplicationRecord
  include Metasploit::Credential::CoreValidations

  # @!attribute private
  #   The {Metasploit::Credential::Private} either gathered from {#realm} or used to
  #   {Metasploit::Credential::ReplayableHash authenticate to the realm}.
  #
  #   @return [Metasploit::Credential::Private, nil]
  belongs_to :private,
             optional: true,
             class_name: 'Metasploit::Credential::Private'

  # @!attribute public
  #   The {Metasploit::Credential::Public} gathered from {#realm}.
  #
  #   @return [Metasploit::Credential::Public, nil]
  belongs_to :public,
             optional: true,
             class_name: 'Metasploit::Credential::Public'

  # @!attribute realm
  #   The {Metasploit::Credential::Realm} where {#private} and/or {#public} was gathered and/or the
  #   {Metasploit::Credential::Realm} to which {#private} and/or {#public} can be used to authenticate.
  #
  #   @return [Metasploit::Credential::Realm, nil]
  belongs_to :realm,
             optional: true,
             class_name: 'Metasploit::Credential::Realm'

  # @!attribute workspace
  #   The `Mdm::Workspace` to which this core credential is scoped.  Used to limit mixing of different networks
  #   credentials.
  #
  #   @return [Mdm::Workspace]
  belongs_to :workspace,
             class_name: 'Mdm::Workspace'

  # @!attribute brute_force_guess_attempts
  #   Attempts to use this core credential against different `Mdm::Service` than the one from which it was originally
  #   gathered.
  #
  #   @return [ActiveRecord::Relation<BruteForce::Guess::Attempt>]
  has_many :brute_force_guess_attempts,
           class_name: 'BruteForce::Guess::Attempt',
           dependent: :destroy,
           foreign_key: :brute_force_guess_core_id,
           inverse_of: :brute_force_guess_core


  def to_credential
    Metasploit::Framework::Credential.new(
      public:       public.try(:username) || '',
      private:      private.try(:data)    || '',
      private_type: private.try(:type).try(:demodulize).try(:underscore).try(:to_sym),
      realm:        realm.try(:value),
      realm_key:    realm.try(:key),
      parent:       self
    )
  end


end
