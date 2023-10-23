class BruteForce::Guess::GuessController < ApplicationController
  before_action :application_backbone, only: [:index,:create]
  before_action :load_workspace

  include TableResponder

  has_scope :workspace_id, only: [:create]

  def index
    @licensed = License.get.supports_bruteforce?
    respond_to do |format|
      format.html{
        gon.workspace_cred_count = Metasploit::Credential::Core.where(workspace_id: @workspace).count
      }
    end
  end

  # If we are coming from the analysis-host/service screen.
  # Unobstrusive JS helper hits this action :-/
  def create
    @licensed = License.get.supports_bruteforce?

    respond_to do |format|
      format.html{
        gon.workspace_cred_count = Metasploit::Credential::Core.where(workspace_id: @workspace).count
        gon.host_ips = host_addresses

        render :index
      }
    end
  end

  private

  # @return [Array] the addresses of hosts to be included in this run
  def host_addresses
    if params[:host_ids]
      Mdm::Host.select(:address).where(id:params[:host_ids],workspace_id: @workspace)
    elsif params[:selections]
      records = records_from_selection_params( params[:class], params[:selections] )

      if records.first.try(:class) == Mdm::Host
        records = records.select( 'address' ).uniq.to_a.compact
      else
        records = records.select( Arel.star ).distinct.collect( &:host ).compact
        records = Mdm::Host.find(records.pluck(:id))
      end

      records
    end
  end

end
