class MetricConfigurationsController < ApplicationController
  def save
    metric_configuration = KalibroGem::Entities::MetricConfiguration.new(params[:metric_configuration])

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
end
