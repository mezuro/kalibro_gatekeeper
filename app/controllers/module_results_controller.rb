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

  def children_of
    begin
      module_result = KalibroGem::Entities::ModuleResult.find(params[:id])
      children = {module_results: module_result.children.map { |m| m.to_hash }}
    rescue KalibroGem::Errors::RecordNotFound
      module_result = {error: 'RecordNotFound'}
    end

    respond_to do |format|
      if module_result.is_a?(KalibroGem::Entities::ModuleResult)
        format.json { render json: children }
      else
        format.json { render json: module_result, status: :unprocessable_entity }
      end
    end
  end

  def history_of
    date_module_results = {date_module_results: KalibroGem::Entities::ModuleResult.history_of(params[:id]).map { |date_module_result| date_module_result.to_hash }}

    respond_to do |format|
      format.json { render json: date_module_results }
    end
  end
end
