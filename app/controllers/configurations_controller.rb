class ConfigurationsController < ApplicationController
  def exists
    exists = { exists: KalibroGem::Entities::Configuration.exists?(params[:id]) }

    respond_to do |format|
      format.json { render json: exists }
    end
  end

  def all
    configurations = {configurations: KalibroGem::Entities::Configuration.all.map { |configuration| configuration.to_hash }}

    respond_to do |format|
      format.html { render json: configurations }
      format.json { render json: configurations }
    end
  end

  def save
    configuration = KalibroGem::Entities::Configuration.new(params[:configuration])

    respond_to do |format|
      if configuration.save
        format.json { render json: configuration.to_hash }
      else
        format.json { render json: configuration.to_hash, status: :unprocessable_entity }
      end
    end
  end

  def get
    begin
      configuration = KalibroGem::Entities::Configuration.find(params[:id])
    rescue KalibroGem::Errors::RecordNotFound
      configuration = {error: 'RecordNotFound'}
    end

    respond_to do |format|
      if configuration.is_a?(KalibroGem::Entities::Configuration)
        format.json { render json: configuration.to_hash }
      else
        format.json { render json: configuration, status: :unprocessable_entity }
      end
    end
  end
end
