class BaseToolsController < ApplicationController
  def all_names
    names = {base_tool_names: KalibroGem::Entities::BaseTool.all_names}

    respond_to do |format|
      format.html { render json: names }
      format.json { render json: names }
    end
  end

  def get
    base_tool = KalibroGem::Entities::BaseTool.find_by_name(params[:name]).to_hash

    respond_to do |format|
      format.json { render json: base_tool }
    end
  end
end
