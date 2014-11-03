class ReadingsController < ApplicationController
  def save
    if params[:reading][:id].nil? || params[:reading][:id].to_i == 0
      params[:reading].delete(:id)
      response = KalibroConfiguration.request("reading_groups/#{params[:reading][:group_id]}/readings", {reading: params[:reading]})
    else
      path = "reading_groups/#{params[:reading][:group_id]}/readings/#{params[:reading][:id]}"
      params[:reading].delete(:id)
      params[:reading_group_id] = params[:reading].delete(:group_id)
      response = KalibroConfiguration.request(path, {reading: params[:reading]}, :put)
    end

    conform_to_gatekeeper_client response["reading"]

    respond_to do |format|
      if response["reading"]["errors"].nil?
        format.json { render json: response["reading"] }
      else
        response["reading"]["kalibro_errors"] = response["reading"].delete("errors")
        format.json { render json: response["reading"], status: :unprocessable_entity }
      end
    end
  end

  def get
    # The reading_group_id is not necessary and we do not know it either. So we just send 0
    reading = KalibroConfiguration.request("reading_groups/0/readings/#{params[:id]}", {}, :get)

    respond_to do |format|
      if reading['error'].nil?
        conform_to_gatekeeper_client reading["reading"]
        format.json { render json: reading["reading"] }
      else
        format.json { render json: reading, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # The reading_group_id is not necessary and we do not know it either. So we just send 0
    KalibroConfiguration.request("reading_groups/0/readings/#{params[:id]}", {}, :delete)

    respond_to do |format|
      format.json { render json: {}, status: :ok }
    end
  end

  def of
    readings =  KalibroConfiguration.request("reading_groups/#{params[:reading_group_id]}/readings", {}, :get)
    readings["readings"].each do |reading|
      conform_to_gatekeeper_client reading
    end
    respond_to do |format|
      format.json { render json: readings }
    end
  end

  private

  def conform_to_gatekeeper_client(reading_hash)
    reading_hash.delete("created_at")
    reading_hash.delete("updated_at")
    reading_hash["group_id"] = reading_hash.delete("reading_group_id")
  end
end
