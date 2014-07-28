class ProcessingsController < ApplicationController
  def has
    exists = {exists: KalibroProcessor.request("repositories/#{params[:repository_id]}/has_processing", {}, :get)["has_processing"] }

    respond_to do |format|
      format.json { render json: exists }
    end
  end

  def has_ready
    exists = {exists: KalibroProcessor.request("repositories/#{params[:repository_id]}/has_ready_processing", {}, :get)["has_ready_processing"] }

    respond_to do |format|
      format.json { render json: exists }
    end
  end

  def has_after
    exists = {exists: KalibroProcessor.request("repositories/#{params[:repository_id]}/has_processing/after", {}, :get)["has_processing_in_time"] }

    respond_to do |format|
      format.json { render json: exists }
    end
  end

  def has_before
    exists = {exists: KalibroProcessor.request("repositories/#{params[:repository_id]}/has_processing/before", {}, :get)["has_processing_in_time"] }

    respond_to do |format|
      format.json { render json: exists }
    end
  end

  def last_state_of
    state = {'state' => KalibroProcessor.request("repositories/#{params[:repository_id]}/last_processing_state", {}, :get)["processing_state"]}

    respond_to do |format|
      format.json { render json: state }
    end
  end

  def last_ready_of
    processing = {"processing" => KalibroProcessor.request("repositories/#{params[:repository_id]}/last_ready_processing", {}, :get)["last_ready_processing"]}

    respond_to do |format|
      format.json { render json: fix_processing_params(processing) }
    end
  end

  def last_of
    processing_hash = KalibroProcessor.request("repositories/#{params[:repository_id]}/last_processing", {})

    respond_to do |format|
      format.json { render json: fix_processing_params(processing_hash) }
    end
  end

  def first_of
    processing_hash = KalibroProcessor.request("repositories/#{params[:repository_id]}/first_processing", {})

    respond_to do |format|
      format.json { render json: fix_processing_params(processing_hash) }
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

  private

  def fix_processing_params(processing)
    processing["processing"].delete('process_time_id')
    processing["processing"].delete('repository_id')
    processing["processing"].delete('created_at')
    processing["processing"]['date'] = processing["processing"].delete('updated_at')
    processing["processing"]['results_root_id'] = processing["processing"].delete('root_module_result_id')
    processing
  end
end
