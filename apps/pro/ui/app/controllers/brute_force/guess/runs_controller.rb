# Used to kick off a BruteForce::Run
class BruteForce::Guess::RunsController < ApplicationController

  before_action :load_workspace

  respond_to :json

  #TODO: Create BruteForce::Guess:Run. Stubbed out task for now
  def create
    string_values_to_bool!(params[:quick_bruteforce])
    runPresenter = BruteForce::Quick::Launch.new(params.merge({
                                                                workspace: @workspace,
                                                                current_user: current_user
                                                              }))
    if runPresenter.valid?(:stand_alone)
      unless params[:validate_only]
        runPresenter.run
        task_data = runPresenter.task_data
        task = Mdm::Task.find(task_data['task_id'])
        redirect_path = task_detail_path(@workspace, task)
      end

      if params[:quick_bruteforce][:file]
        render :partial => 'shared/iframe_transport_response', :locals => { :data => { :success => true, redirect_to: redirect_path }}
      else
        render json: {success: :ok, redirect_to: redirect_path}, status: :ok
      end
    else
      if params[:quick_bruteforce][:file]
        render :partial => 'shared/iframe_transport_response', :locals => { :data => { :success => false, errors: runPresenter.errors_hash}}
      else
        render json: {errors: runPresenter.errors_hash}, status: :error
      end
    end
  end

  def target_count
    if params[:quick_bruteforce][:targets][:type] == "all"
      whitelist_hosts = ''
    else
      whitelist_hosts = params['quick_bruteforce']['targets']['whitelist_hosts']
    end

    begin

      target_selector = ::BruteForce::Quick::TargetSelector.new(
        blacklist_hosts: params['quick_bruteforce']['targets']['blacklist_hosts'],
        services: params['quick_bruteforce']['targets']['services'],
        whitelist_hosts: whitelist_hosts,
        workspace: @workspace
      )

      targets_count = target_selector.target_services.count

      render json: {count: targets_count}
    rescue ActiveRecord::StatementInvalid
      render json: {count: 0}
    end


  end

  def string_values_to_bool!(hash)
    hash.each do |k,v|
      if (v == true)||(v == 'true')
        hash[k] = true
      elsif (v == false)||(v == 'false')
        hash[k] = false
      elsif v.class == ActionController::Parameters
        string_values_to_bool!(v)
      end
    end
  end

end
