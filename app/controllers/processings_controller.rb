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
    exists = {exists: KalibroProcessor.request("repositories/#{params[:repository_id]}/has_processing/after", {"date" => params[:date]})["has_processing_in_time"] }

    respond_to do |format|
      format.json { render json: exists }
    end
  end

  def has_before
    exists = {exists: KalibroProcessor.request("repositories/#{params[:repository_id]}/has_processing/before", {"date" => params[:date]})["has_processing_in_time"] }

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
    processing_hash = {"processing" => KalibroProcessor.request("repositories/#{params[:repository_id]}/last_ready_processing", {}, :get)["last_ready_processing"]}
    processing_id = processing_hash["processing"]["id"].to_i
    process_times = KalibroProcessor.request("processings/#{processing_id}/process_times", {}, :get)["process_times"]

    respond_to do |format|
      format.json { render json: fix_processing_params(processing_hash, process_times) }
    end
  end

  def last_of
    processing_hash = KalibroProcessor.request("repositories/#{params[:repository_id]}/last_processing", {})
    processing_id = processing_hash["processing"]["id"].to_i
    process_times = KalibroProcessor.request("processings/#{processing_id}/process_times", {}, :get)["process_times"]

    respond_to do |format|
      format.json { render json: fix_processing_params(processing_hash, process_times) }
    end
  end

  def first_of
    processing_hash = KalibroProcessor.request("repositories/#{params[:repository_id]}/first_processing", {})
    processing_id = processing_hash["processing"]["id"].to_i
    process_times = KalibroProcessor.request("processings/#{processing_id}/process_times", {}, :get)["process_times"]

    respond_to do |format|
      format.json { render json: fix_processing_params(processing_hash, process_times) }
    end
  end

  def first_after_of
    processing_hash = KalibroProcessor.request("repositories/#{params[:repository_id]}/first_processing/after", {"date" => params[:date]})
    processing_id = processing_hash["processing"]["id"].to_i
    process_times = KalibroProcessor.request("processings/#{processing_id}/process_times", {}, :get)["process_times"]

    respond_to do |format|
      format.json { render json: fix_processing_params(processing_hash, process_times) }
    end
  end

  def last_before_of
    processing_hash = KalibroProcessor.request("repositories/#{params[:repository_id]}/last_processing/before", {"date" => params[:date]})
    processing_id = processing_hash["processing"]["id"].to_i
    process_times = KalibroProcessor.request("processings/#{processing_id}/process_times", {}, :get)["process_times"]

    respond_to do |format|
      format.json { render json: fix_processing_params(processing_hash, process_times) }
    end
  end

  private

  def fix_process_times(process_times)
    process_times.map do |process_time|
      KalibroGem::Entities::ProcessTime.new(state: process_time["state"], time: process_time['time'])
    end
  end

  def fix_processing_params(processing, process_times)
    processing["processing"].delete('process_time_id')
    processing["processing"].delete('repository_id')
    processing["processing"].delete('created_at')
    processing["processing"]['date'] = processing["processing"].delete('updated_at')
    processing["processing"]['results_root_id'] = processing["processing"].delete('root_module_result_id')

    processing["processing"]["process_time"] = fix_process_times(process_times)

    processing
  end
end
