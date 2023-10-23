class Fuzzing::FuzzingController < ApplicationController

  before_action :load_workspace, :only => [ :index ]
  before_action :my_load_workspace, :except => [ :index ]
  #before_action :check_license
  before_action :check_fuzzing_support
  before_action :redirect_if_not_licensed, :except => [ :index ]


	def index
		
    return redirect_to workspace_url(@workspace, :anchor=>'') unless License.get.supports_fuzzing_frame?

		respond_to do |format|
			format.html
			format.json do
				render :json => {}
			end
		end
	end

  private

  def check_fuzzing_support
    redirect_to workspace_url(@workspace, :anchor=>'') unless License.get.supports_fuzzing_frame?
  end

end
