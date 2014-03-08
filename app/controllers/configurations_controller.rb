class ConfigurationsController < ApplicationController
  def exists
    exists = { exists: KalibroGem::Entities::Configuration.exists?(params[:id]) }

    respond_to do |format|
      format.json { render json: exists }
    end
  end

  def all
    configurations = {configurations: KalibroGem::Entities::Configuration.all.map { |configuration| configuration.to_hash }}

    respond_to do |format|
      format.html { render json: configurations }
      format.json { render json: configurations }
    end
  end
end
