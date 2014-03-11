class BaseToolsController < ApplicationController
  def all_names
    names = {base_tool_names: KalibroGem::Entities::BaseTool.all_names}

    respond_to do |format|
      format.html { render json: names }
      format.json { render json: names }
    end
  end

  def get
    begin
      base_tool = KalibroGem::Entities::BaseTool.find_by_name(params[:name])
    rescue KalibroGem::Errors::RecordNotFound
      base_tool = {error: 'RecordNotFound'}
    end

    respond_to do |format|
      if base_tool.is_a?(KalibroGem::Entities::BaseTool)
        format.json { render json: base_tool.to_hash }
      else
        format.json { render json: base_tool, status: :unprocessable_entity }
      end
    end
  end
end
