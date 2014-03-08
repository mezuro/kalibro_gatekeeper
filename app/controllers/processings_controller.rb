class ProcessingsController < ApplicationController
  def has
    exists = {exists: KalibroGem::Entities::Processing.has_processing(params[:repository_id])}

    respond_to do |format|
      format.json { render json: exists }
    end
  end
end
