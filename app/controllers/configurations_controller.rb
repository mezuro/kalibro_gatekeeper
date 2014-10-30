class ConfigurationsController < ApplicationController
  def exists
    exists = KalibroConfiguration.request("kalibro_configurations/#{params[:id]}/exists", {}, :get)

    respond_to do |format|
      format.json { render json: exists }
    end
  end

  def all
    configurations_hashes = KalibroConfiguration.request("kalibro_configurations", {}, :get)["kalibro_configurations"]
    configurations_hashes.map { |configuration_hash| configuration_hash.delete("created_at"); configuration_hash.delete("updated_at") }
    configurations = { configurations: configurations_hashes }

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

    response["kalibro_configuration"].delete("created_at")
    response["kalibro_configuration"].delete("updated_at")

    respond_to do |format|
      if response["kalibro_configuration"]["errors"].nil?
        format.json { render json: response["kalibro_configuration"] }
      else
        response["kalibro_configuration"]["kalibro_errors"] = response["kalibro_configuration"].delete("errors")
        format.json { render json: response["kalibro_configuration"], status: :unprocessable_entity }
      end
    end
  end

  def get
    configuration = KalibroConfiguration.request("kalibro_configurations/#{params[:id]}", {}, :get)

    respond_to do |format|
      if configuration['error'].nil?
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
