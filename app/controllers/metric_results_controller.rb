class MetricResultsController < ApplicationController
  def history_of_metric
    repository_id = KalibroProcessor.request("module_results/#{params[:module_result_id]}/repository_id", {}, :get)["repository_id"]
    module_id = KalibroProcessor.request("module_results/#{params[:module_result_id]}/get", {}, :get)["kalibro_module"]["id"]
    history_of_metric = KalibroProcessor.request("repositories/#{module_id}/metric_result_history_of", {module_id: module_id, metric_name: params[:metric_name]})["metric_result_history_of"]
    respond_to do |format|
      format.json { render json: {date_metric_results: history_of_metric} }
    end
  end

  def descendant_results_of
    descendant_results = KalibroProcessor.request("metric_results/#{params[:id]}/descendant_values", {}, :get)["descendant_values"]
    respond_to do |format|
      format.json { render json: { descendant_results: descendant_results } }
    end
  end

  def of
    metric_results = KalibroProcessor.request("module_results/#{params[:module_result_id]}/metric_results", {}, :get)

    metric_results.each do |metric_result|
      add_snapshot(metric_result)
      metric_result.delete('created_at')
      metric_result.delete('updated_at')
      metric_result.delete('module_result_id')
      metric_result.delete('metric_configuration_id')
    end

    respond_to do |format|
      format.json { render json: {metric_results: metric_results} }
    end
  end

  private

  def add_snapshot(metric_result_hash)
    metric_configuration = KalibroGem::Entities::MetricConfiguration.find(metric_result_hash['metric_configuration_id'].to_i)
    ranges = KalibroGem::Entities::Range.ranges_of(metric_result_hash['metric_configuration_id'].to_i)

    range_snapshots = ranges.map do |range|
      reading = KalibroGem::Entities::Reading.find(range.reading_id)
      KalibroGem::Entities::RangeSnapshot.new(beginning: range.beginning, end: range.end, label: reading.label,
                                              grade: reading.grade, color: reading.color, comments: range.comments)
    end

    metric_result_hash["configuration"] = KalibroGem::Entities::MetricConfigurationSnapshot.
                                            new(range: range_snapshots, code: metric_configuration.code,
                                                weight: metric_configuration.weight, aggregation_form: metric_configuration.aggregation_form,
                                                metric: metric_configuration.metric, base_tool_name: metric_configuration.base_tool_name)
  end
end
