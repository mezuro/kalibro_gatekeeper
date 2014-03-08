class MetricResultsController < ApplicationController
  def history_of_metric
    history_of_metric = {date_metric_results: KalibroGem::Entities::MetricResult.history_of(params[:metric_name], params[:module_result_id]).map { |date_metric_result| date_metric_result.to_hash }}

    respond_to do |format|
      format.json { render json: history_of_metric }
    end
  end

  def descendant_results_of
    descendant_results = {descendant_results: KalibroGem::Entities::MetricResult.descendant_results(params[:id])}

    respond_to do |format|
      format.json { render json: descendant_results }
    end
  end

  def of
    metric_results = {metric_results: KalibroGem::Entities::MetricResult.metric_results_of(params[:module_result_id]).map { |metric_result| metric_result.to_hash }}

    respond_to do |format|
      format.json { render json: metric_results }
    end
  end
end
