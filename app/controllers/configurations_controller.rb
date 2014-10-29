class ConfigurationsController < ApplicationController
  def exists
    exists = KalibroConfiguration.request("kalibro_configurations/#{params[:id]}/exists", {}, :get)

    respond_to do |format|
      format.json { render json: exists }
    end
  end

  def all
    configurations = { configurations: KalibroConfiguration.request("kalibro_configurations", {}, :get)[:kalibro_configurations] }

    respond_to do |format|
      format.html { render json: configurations }
      format.json { render json: configurations }
    end
  end

  def save
    if params[:configuration][:id].nil? || params[:configuration][:id].to_i == 0
      params[:configuration].delete(:id)
      response = KalibroConfiguration.request("kalibro_configurations", {kalibro_configuration: params[:configuration]})
    else
      path = "kalibro_configurations/#{params[:configuration][:id]}"
      params[:configuration].delete(:id)
      response = KalibroConfiguration.request(path, {kalibro_configuration: params[:configuration]}, :put)
    end

    respond_to do |format|
      if response[:kalibro_configuration][:errors].nil?
        format.json { render json: response }
      else
        format.json { render json: response, status: :unprocessable_entity }
      end
    end
  end

  def get
    configuration = KalibroConfiguration.request("kalibro_configurations/#{params[:id]}", {}, :get)

    respond_to do |format|
      if configuration[:error].nil?
        format.json { render json: configuration }
      else
        format.json { render json: configuration, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    KalibroConfiguration.request("kalibro_configurations/#{params[:id]}", {}, :delete)

    respond_to do |format|
      format.json { render json: {}, status: :ok }
    end
  end
end
