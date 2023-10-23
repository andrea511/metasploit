
class Shared::PayloadSettingsController < ApplicationController
  before_action :load_workspace

  def index
    respond_to do |format|
      format.json{
        render json: {
          macros: Mdm::Macro.select([:id,:name]).all,
        }
      }
    end
  end


  def create
    payloadSettingsPresenter = Shared::PayloadSettingsValidator.new(params[:payload_settings])

    respond_to do |format|
      format.json{
        if payloadSettingsPresenter.valid?
          render json: {}, status: :ok
        else
          render json: {errors:payloadSettingsPresenter.errors}, status: :error
        end
      }
    end

  end

end
