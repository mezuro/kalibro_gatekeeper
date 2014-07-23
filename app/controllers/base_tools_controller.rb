class BaseToolsController < ApplicationController
  def all_names
    names = KalibroProcessor.request("base_tools", {}, :get)

    respond_to do |format|
      format.html { render json: names }
      format.json { render json: names }
    end
  end

  def get
    base_tool = KalibroProcessor.request("base_tools/#{params[:name]}/find", {}, :get)

    respond_to do |format|
      if base_tool["error"].nil?
        # The client expects the supported metrics inside a Array, without code and the key on singular
        base_tool["base_tool"]["supported_metric"] = []
        base_tool["base_tool"]["supported_metrics"].each {|code, metric| base_tool["base_tool"]["supported_metric"] << metric}
        base_tool["base_tool"].delete("supported_metrics")

        format.json { render json: base_tool["base_tool"] }
      else
        format.json { render json: base_tool, status: :unprocessable_entity }
      end
    end
  end
end
