class MetricConfigurationsController < ApplicationController
  def save
    params[:metric_configuration][:metric].delete(:code)
    metric_configuration = KalibroGem::Entities::MetricConfiguration.new(params[:metric_configuration])
    metric_configuration.configuration_id = params[:configuration_id]
    metric_configuration.id = nil

    #Sending this garbage just because KalibroJava is waiting Prezento to send an aggregation form
    if metric_configuration.metric.compound == "true"
      metric_configuration.aggregation_form = "AVERAGE"
    end

    respond_to do |format|
      if metric_configuration.save
        format.json { render json: metric_configuration.to_hash }
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
        format.json { render json: metric_configuration.to_hash }
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
        format.json { render json: metric_configuration.to_hash }
      else
        format.json { render json: metric_configuration, status: :unprocessable_entity }
      end
    end
  end

  def of
    metric_configurations = {metric_configurations: KalibroGem::Entities::MetricConfiguration.metric_configurations_of(params[:configuration_id]).map { |metric_configuration| metric_configuration.to_hash }}

    respond_to do |format|
      format.json { render json: metric_configurations }
    end
  end
end
