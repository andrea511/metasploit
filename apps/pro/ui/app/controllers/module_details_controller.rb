class ModuleDetailsController < ApplicationController
  before_action :find_module_detail

  def show
    respond_to do |format|
      format.json do
        build_refs
      end
    end
  end


  private

  def find_module_detail
    @module_detail = Mdm::Module::Detail.find(params[:id])
  end

  def build_refs
    @refs = @module_detail.refs
  end

end
