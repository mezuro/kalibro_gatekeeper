class BaseToolsController < ApplicationController
  def all_names
    names = {base_tool_names: KalibroGem::Entities::BaseTool.all_names}

    respond_to do |format|
      format.html { render json: names }
      format.json { render json: names }
    end
  end
end
