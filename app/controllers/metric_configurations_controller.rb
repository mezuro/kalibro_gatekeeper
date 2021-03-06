class MetricConfigurationsController < ApplicationController
  def save
    params[:metric_configuration][:metric].delete(:code)
    params[:metric_configuration][:base_tool_name] = params[:metric_configuration].delete(:metric_collector_name)
    metric_configuration = KalibroGem::Entities::MetricConfiguration.new(params[:metric_configuration])
    metric_configuration.configuration_id = params[:configuration_id]
    metric_configuration.id = nil if metric_configuration.id == 0

    #Sending this garbage just because KalibroJava is waiting Prezento to send an aggregation form
    if metric_configuration.metric.compound == "true"
      metric_configuration.aggregation_form = "AVERAGE"
    end

    respond_to do |format|
      if metric_configuration.save
        format.json { render json: set_metric_collector_name(metric_configuration.to_hash) }
      else
        format.json { render json: metric_configuration.to_hash, status: :unprocessable_entity }
      end
    end
  end

  def get
    begin
      metric_configuration = KalibroGem::Entities::MetricConfiguration.find(params[:id])
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
