class ModuleResultsController < ApplicationController
  def get
    module_result = KalibroProcessor.request("module_results/#{params[:id]}/get", {}, :get)
    module_result.delete("created_at")
    module_result.delete("updated_at")
    module_result.delete("processing_id")

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
    p children
    children.each do |children|
      children.delete("created_at")
      children.delete("updated_at")
      children.delete("processing_id")
    end

    respond_to do |format|
      if children.is_a?(Array) #Processor returns an array of children when sucessful and an error hash when it fails.
        format.json { render json: {"module_results" => children} }
      else
        format.json { render json: children, status: :unprocessable_entity }
      end
    end
  end

  def history_of
    repository_id = KalibroProcessor.request("module_results/#{params[:id]}/repository_id", {}, :get)['repository_id']
    date_module_results = {date_module_results: KalibroProcessor.request("repositories/#{repository_id}/module_result_history_of", {}, :get)}

    respond_to do |format|
      format.json { render json: date_module_results }
    end
  end
end
