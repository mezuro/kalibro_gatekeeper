class ModuleResultsController < ApplicationController
  def get
    begin
      module_result = KalibroGem::Entities::ModuleResult.find(params[:id])
    rescue KalibroGem::Errors::RecordNotFound
      module_result = {error: 'RecordNotFound'}
    end

    respond_to do |format|
      if module_result.is_a?(KalibroGem::Entities::ModuleResult)
        format.json { render json: module_result.to_hash }
      else
        format.json { render json: module_result, status: :unprocessable_entity }
      end
    end
  end
end
