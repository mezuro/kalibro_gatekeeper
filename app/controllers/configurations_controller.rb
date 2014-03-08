class ConfigurationsController < ApplicationController
  def exists
    exists = { exists: KalibroGem::Entities::Configuration.exists?(params[:id]) }

    respond_to do |format|
      format.json { render json: exists }
    end
  end
end
