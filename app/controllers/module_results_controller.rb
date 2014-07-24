class ModuleResultsController < ApplicationController
  def get
    module_result = KalibroProcessor.request("module_results/#{params[:id]}/get", {}, :get)

    respond_to do |format|
      if module_result["error"].nil?
        format.json { render json: module_result }
      else
        format.json { render json: module_result, status: :unprocessable_entity }
      end
    end
  end

  def children_of
    children = KalibroProcessor.request("module_results/#{params[:id]}/children", {}, :get)

    respond_to do |format|
      if children.is_a?(Array) #Processor returns an array of children when sucessful and an error hash when it fails.
        format.json { render json: {"module_results" => children} }
      else
        format.json { render json: children, status: :unprocessable_entity }
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
