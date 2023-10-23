# Auto-loading tends to fail in multi-threaded situations
require 'web/proof'
require 'web/vuln_category/metasploit'

# Mix into Msf::DBManager to allow Msf::DBManager#report_web_vuln to use the {Web::VulnCategory} hierarchy instead of
# the simple string based Mdm::WebVuln#category.
module Web::VulnCategory::Mixin

  def report_web_vuln(options={})
     report_web_vuln_with_web_vuln_category(options)
  end

  #
  # CONSTANTS
  #

  # Valid option keys for {#first_or_create_web_site!}
  FIRST_OR_CREATE_WEB_SITE_VALID_KEYS = [
      :host,
      :port,
      :service,
      :ssl,
      :vhost,
      :web_site,
      :workspace
  ]

  #
  # Instance Methods
  #

  # Creates or updates an Mdm::WebVuln in the database.  The Mdm::WebVuln must be tied to either a Mdm::WebSite or a
  # {Web::Request}.
  #
  # @note this does not call report_web_vuln_without_web_vuln_category because there is no part of the
  #   Msf::DBManager#report_web_vuln behavior that can be reused.
  #
  # @param options [Hash{Symbol => Object}] options of the Mdm::WebVuln
  # @param options [String] :blame a description of who to blame for the Mdm::WebVuln, such as the developer or
  #   sysadmin.
  # @option options [String] :category a {Web::VulnCategory::Metasploit#name}
  # @option options [Integer] :confidence confidence between 1 and 100 inclusive.
  # @option options [ActiveSupport::TimeWithZone] :created_at When the Mdm::WebVuln was created.
  # @option options [String] :description a description of the vulnerability, which is more verbose than `:category` or
  #   `:name`.
  # @option options ['GET', 'PATH', 'POST'] :method the form method
  # @option options [String] :name the type of vulnerability
  # @option options [Array<Array<String>>] :params ([]) an ARRAY of all parameters and values specified in the form
	# @option options [String] :path the virtual host name for this particular web site
  # @option options [String] :payload the payload portion of request that demonstrates the vulnerability
  # @option options [String] :pname the specific field where the vulnerability occurs
  # @option options [String] :proof the string showing proof of the vulnerability
  # @option options [Array<Hash{Symbol => String}] :proofs_attributes attributes for {Web::Proof Web::Proofs}.
  # @option options [String] :query the query string appended to the path (not valid for GET method flaws)
  # @option options [Integer, #to_i] :risk an INTEGER value from 0 to 5 indicating the risk (5 is highest)
  #   Used by Msf::DBManager#msf_import_timestamps.
  # @option options [ActiveSupport::TimeWithZone] :updated_at When the Mdm::WebVuln was updated.  Used by
  #   Msf::DBManager#msf_import_timestamps.
  # @option options [Mdm::Workspace] :workspace the workspace in which the Mdm::Host exists for the Mdm::Service for the
  #   Mdm::WebSite for the Mdm::WebVuln.
  # @option (see #first_or_create_web_site!)
  #
  # @return [Mdm::WebVuln] The created or updated Mdm::WebVuln
  # @see (see #first_or_create_web_site!)

  # @raise [ActiveRecord::RecordInvalid] if Mdm::WebVuln is invalid.  Look at `error.record.errors` for the validation
  #   errors.
  def report_web_vuln_with_web_vuln_category(options={})
    # convert any String keys to Symbols so that assert_valid_keys doesn't have to check both formats
    symbolized_options = options.symbolize_keys
    symbolized_options.assert_valid_keys(
        FIRST_OR_CREATE_WEB_SITE_VALID_KEYS,
        :blame,
        :category,
        :confidence,
        :created_at,
        :description,
        :method,
        :name,
        :owner,
        :params,
        :path,
        :payload,
        :pname,
        :proof,
        :proofs_attributes,
        :query,
        :risk,
        :updated_at,
        :workspace,
        :task
    )

    web_vuln = nil

    # Do nothing if the database is not enabled. (This would be odd for Pro, but this mimic the check in
    # Msf::DBManager#report_web_vuln.)
    if active
      workspace = symbolized_options[:workspace]

      ApplicationRecord.connection_pool.with_connection do
        workspace ||= self.workspace

        web_site = first_or_create_web_site!(
            :host => symbolized_options[:host],
            :port => symbolized_options[:port],
            :service => symbolized_options[:service],
            :ssl => symbolized_options[:ssl],
            :vhost => symbolized_options[:vhost],
            :web_site => symbolized_options[:web_site],
            :workspace => workspace
        )

        web_vuln_query = Mdm::WebVuln.where(
            :method => symbolized_options[:method],
            :name => symbolized_options[:name],
            :path => symbolized_options[:path],
            :pname => symbolized_options[:pname],
            :query => symbolized_options[:query],
            :web_site_id => web_site.id,
        )

        category_attributes = category_attributes_from_name(symbolized_options[:category])

        web_vuln_query = web_vuln_query.where(
            category_attributes
        )

        # call first instead of first_or_create! so that setting updateable attributes only happens once for the create
        # or update branch
        web_vuln = web_vuln_query.first_or_initialize

        web_vuln.blame = symbolized_options[:blame]
        web_vuln.confidence = symbolized_options[:confidence]
        web_vuln.description = symbolized_options[:description]

        owner = symbolized_options[:owner]
        web_vuln.owner = owner.try(:shortname)

        web_vuln.params = symbolized_options[:params]
        web_vuln.payload = symbolized_options[:payload]

        find_or_build_web_proofs(
            :proofs_attributes => symbolized_options[:proofs_attributes],
            :text => symbolized_options[:proof],
            :web_vuln => web_vuln
        )

        web_vuln.risk = symbolized_options[:risk]

        msf_import_timestamps(symbolized_options, web_vuln)

        web_vuln.save!
      end
    end

    web_vuln
  end

  private

  # Finds the {Web::VulnCategory::Metasploit} with the given name.  If name is not a
  # {Web::VulnCategory::Metasploit#name} then falls back to Mdm::WebVuln#legacy_category.
  #
  # @param name [String] the {Web:VulnCategory::Metasploit#name} that was previously seeded in the database or a
  #   legacy category from an import.
  # @return [Hash{Symbol => Integer}] {:category_id => Web::VulnCategory::Metasploit#id} if name is a
  #   {Web::VulnCategory::Metasploit#name}.
  # @return [Hash{Symbol => String}] {:legacy_category => name} if name is not a {Web::VulnCategory::Metasploit#name}.
  def category_attributes_from_name(name)
    attributes = {}

    # handle import of non-conforming categories by mapping them to their conforming names as was done in
    # {StandardizeCategoryInWebVulns the migration}.
    potentially_non_conforming_category = name
    name = Web::VulnCategory::Metasploit::NAME_BY_NON_CONFORMING_CATEGORY.fetch(
        potentially_non_conforming_category,
        potentially_non_conforming_category
    )

    category = Web::VulnCategory::Metasploit.where(:name => name).first

    if category
      attributes[:category_id] = category.id
    else
      wlog(
          "#{name} is not a Web::VulnCategory::Metasploit#name, so it is being mapped to Mdm::WebVuln#legacy_category."
      )

      attributes[:legacy_category] = name
    end

    attributes
  end

  # Finds or builds a new textual {Web::Proof} associated with the given Mdm::WebVuln for each set of attributes.
  #
  # @param options [Hash{Symbol => Object}] keyword parameters
  # @option options [Hash{Symbol => String}] :proofs_attributes The attributes for {Web::Proof Web::Proofs}.  If any
  #   {Web::Proof} attributes Hash in `:proof_attributes` has a blank value for the `:text` attribute then a
  #   {Web::Proof} is not searched for or built from that attribute Hash.
  # @option options [String, nil] :text The {Web::Proof#text} for a single {Web::Proof}.  Only used if
  #   :proofs_attributes is `nil`.  If `nil`, then not {Web::Proof} is searched for or built.
  # @option options [Mdm::WebVuln] :web_vuln The {Mdm::WebVuln} that requires proof.
  #
  # @return [Array<Web::Proof>]
  # @raise [KeyError] if :web_vuln is not in options.
  def find_or_build_web_proofs(options={})
    options.assert_valid_keys(:proofs_attributes, :text, :web_vuln)

    proofs_attributes = options[:proofs_attributes]

    unless proofs_attributes
      proof_text = options[:text]

      if proof_text.present?
        proof_attributes = {
            :text => proof_text
        }
        proofs_attributes = [proof_attributes]
      else
        proofs_attributes = []
      end
    end

    proofs = []

    proofs_attributes.each do |proof_attributes|
      text = proof_attributes[:text]

      if text.present?
        proof_scope = Web::Proof.where(:text => text)

        proof = nil
        web_vuln = options.fetch(:web_vuln)

        unless web_vuln.new_record?
          proof = proof_scope.where(:vuln_id => web_vuln.id).first
        end

        # create a new proof for a new web vuln or a web vuln without a proof with this text
        unless proof
          proof = proof_scope.new
          web_vuln.proofs << proof
        end

        # web_vuln may not have an id, so need to explicitly set both sides of association
        proof.vuln = web_vuln
        proofs << proof
      end
    end

    proofs
  end

  # Like Msf::DBManager#report_web_site, but will raise an ArgumentError if a :web_site is not given or cannot be found
  # or created.
  #
  # @option options [Mdm::WebSite] :web_site the web site with which the Mdm::WebVuln should be associated.
  #
  # If `:web_site` is NOT specified, the following values are mandatory
  # @option options [Mdm::Service] :service the service on which the Mdm::WebSite is.
  # @option options [String] :vhost the virtual host for this particular web site
  #
  # If `:web_site` and `:service` is NOT specified, the following values are mandatory
	# @option options [String] :host the ip address of the server hosting the web site
	# @option options [Integer, #to_i] :port the port number of the associated web site
	# @option options [Boolean] :ssl whether or not SSL is in use on this port
  #
  # @return [Mdm::WebSite] the web site.
  # @raise [ArgumentError] if Msf::DBManager#report_web_site cannot create an Mdm::WebSite using the :host, :port, :ssl,
  #   :vhost, and :workspace.
  def first_or_create_web_site!(options)
    options.assert_valid_keys(FIRST_OR_CREATE_WEB_SITE_VALID_KEYS)

    web_site = options[:web_site]

    unless web_site and web_site.is_a? Mdm::WebSite
      web_site = report_web_site(
          :host => options[:host],
          :port => options[:port],
          :service => options[:service],
          :ssl => options[:ssl],
          :vhost => options[:vhost],
          :workspace => options[:workspace],
      )

      unless web_site
        raise ArgumentError, 'Msf::DBManager#report_web_site was unable to create the associated Mdm::WebSite'
      end
    end

    web_site
  end
end
