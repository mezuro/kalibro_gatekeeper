class ModuleResultsController < ApplicationController
  def get
    module_result = KalibroProcessor.request("module_results/#{params[:id]}/get", {}, :get)

    format_module_result(module_result) if module_result["error"].nil?

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

    children.each { |child| format_module_result(child) } if children.is_a?(Array)

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
    date_module_results = {date_module_results: KalibroProcessor.request("repositories/#{repository_id}/module_result_history_of", {module_id: params[:id]})['module_result_history_of']}

    respond_to do |format|
      format.json { render json: date_module_results }
    end
  end

  private

  def format_module_result(module_result)
    unless module_result["kalibro_module"].nil?
      module_result["kalibro_module"].delete("id")
      module_result["kalibro_module"].delete("created_at")
      module_result["kalibro_module"].delete("updated_at")
      module_result["kalibro_module"].delete("module_result_id")
      module_result["kalibro_module"]["name"] = module_result["kalibro_module"]["long_name"]
      module_result["kalibro_module"].delete("long_name")
      module_result["kalibro_module"]["granularity"] = module_result["kalibro_module"]["granlrty"]
      module_result["kalibro_module"].delete("granlrty")

      module_result["module"] = module_result["kalibro_module"]
      module_result.delete("kalibro_module")
    end

    module_result.delete("created_at")
    module_result.delete("updated_at")
    module_result.delete("processing_id")
  end
end
