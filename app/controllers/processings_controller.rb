class ProcessingsController < ApplicationController
  def has
    exists = {exists: KalibroGem::Entities::Processing.has_processing(params[:repository_id])}

    respond_to do |format|
      format.json { render json: exists }
    end
  end

  def has_ready
    exists = {exists: KalibroGem::Entities::Processing.has_ready_processing(params[:repository_id])}

    respond_to do |format|
      format.json { render json: exists }
    end
  end

  def has_after
    exists = {exists: KalibroGem::Entities::Processing.has_processing_after(params[:repository_id], params[:date])}

    respond_to do |format|
      format.json { render json: exists }
    end
  end

  def has_before
    exists = {exists: KalibroGem::Entities::Processing.has_processing_before(params[:repository_id], params[:date])}

    respond_to do |format|
      format.json { render json: exists }
    end
  end

  def last_state_of
    state = {state: KalibroGem::Entities::Processing.last_processing_state_of(params[:repository_id])}

    respond_to do |format|
      format.json { render json: state }
    end
  end

  def last_ready_of
    processing = {processing: KalibroGem::Entities::Processing.last_ready_processing_of(params[:repository_id]).to_hash}

    respond_to do |format|
      format.json { render json: processing }
    end
  end

  def last_of
    processing = {processing: KalibroGem::Entities::Processing.last_processing_of(params[:repository_id]).to_hash}

    respond_to do |format|
      format.json { render json: processing }
    end
  end

  def first_of
    processing = {processing: KalibroGem::Entities::Processing.first_processing_of(params[:repository_id]).to_hash}

    respond_to do |format|
      format.json { render json: processing }
    end
  end

  def first_after_of
    processing = {processing: KalibroGem::Entities::Processing.first_processing_after(params[:repository_id], params[:date]).to_hash}

    respond_to do |format|
      format.json { render json: processing }
    end
  end

  def last_before_of
    processing = {processing: KalibroGem::Entities::Processing.last_processing_before(params[:repository_id], params[:date]).to_hash}

    respond_to do |format|
      format.json { render json: processing }
    end
  end
end
