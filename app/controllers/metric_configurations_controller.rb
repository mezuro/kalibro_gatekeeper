class MetricConfigurationsController < ApplicationController
  def save
    if params[:metric_configuration][:metric][:compound] == "true"
      params[:metric_configuration][:metric][:type] = "CompoundMetricSnapshot"
    else
      params[:metric_configuration][:metric][:type] = "NativeMetricSnapshot"
    end
    params[:metric_configuration][:metric].delete(:compound)
    params[:metric_configuration][:metric][:metric_collector_name] = params[:metric_configuration].delete(:metric_collector_name)
    params[:metric_configuration][:metric][:code] = params[:metric_configuration].delete(:code)
    params[:metric_configuration][:metric].delete(:language)

    params[:metric_configuration][:kalibro_configuration_id] = params[:configuration_id]
    params[:metric_configuration].delete(:attributes!)

    if params[:metric_configuration][:id].nil? || params[:metric_configuration][:id].to_i == 0
      params[:metric_configuration].delete(:id)
      response = KalibroConfiguration.request("metric_configurations/", {metric_configuration: params[:metric_configuration]})
    else
      path = "metric_configurations/#{params[:metric_configuration][:id]}"
      params[:metric_configuration].delete(:id)
      response = KalibroConfiguration.request(path, {reading: params[:reading]}, :put)
    end

    response["metric_configuration"].delete("created_at")
    response["metric_configuration"].delete("updated_at")
    response["metric_configuration"].delete("metric_snapshot_id")
    response["metric_configuration"]["configuration_id"] = response["metric_configuration"].delete("kalibro_configuration_id")

    respond_to do |format|
      if response['errors'].nil?
        format.json { render json: response["metric_configuration"] }
      else
        format.json { render json: response["metric_configuration"], status: :unprocessable_entity }
      end
    end
  end

  def get
    metric_configuration = KalibroConfiguration.request("metric_configurations/#{params[:id]}", {}, :get)

    metric_configuration["metric_configuration"].delete("created_at")
    metric_configuration["metric_configuration"].delete("updated_at")
    metric_configuration["metric_configuration"].delete("metric_snapshot_id")
    metric_configuration["metric_configuration"]["configuration_id"] = metric_configuration["metric_configuration"].delete("kalibro_configuration_id")

    respond_to do |format|
      if metric_configuration['error'].nil?
        format.json { render json: metric_configuration["metric_configuration"] }
      else
        format.json { render json: metric_configuration, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    begin
      metric_configuration = KalibroGem::Entities::MetricConfiguration.find(params[:id])
      metric_configuration.destroy
    rescue KalibroGem::Errors::RecordNotFound
      metric_configuration = {error: 'RecordNotFound'}
    end

    respond_to do |format|
      if metric_configuration.is_a?(KalibroGem::Entities::MetricConfiguration)
        format.json { render json: set_metric_collector_name(metric_configuration.to_hash) }
      else
        format.json { render json: metric_configuration, status: :unprocessable_entity }
      end
    end
  end

  def of
    metric_configurations = {metric_configurations: KalibroGem::Entities::MetricConfiguration.metric_configurations_of(params[:configuration_id]).map { |metric_configuration| metric_configuration.to_hash }}

    respond_to do |format|
      metric_configurations[:metric_configurations].map do |metric_configuration_hash|
        set_metric_collector_name(metric_configuration_hash)
      end
      format.json { render json: metric_configurations }
    end
  end

  private

  def set_metric_collector_name(metric_configuration_hash)
    metric_configuration_hash[:metric_collector_name] = metric_configuration_hash.delete(:base_tool_name)
    metric_configuration_hash
  end
end
