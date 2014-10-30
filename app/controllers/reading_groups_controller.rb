class ReadingGroupsController < ApplicationController
  def exists
    exists = KalibroConfiguration.request("reading_groups/#{params[:id]}/exists", {}, :get)

    respond_to do |format|
      format.json { render json: exists }
    end
  end

  def all
    reading_groups_hashes = KalibroConfiguration.request("reading_groups", {}, :get)["reading_groups"]
    reading_groups_hashes.map { |reading_group_hash| reading_group_hash.delete("created_at"); reading_group_hash.delete("updated_at") }
    reading_groups = { reading_groups: reading_groups_hashes }

    respond_to do |format|
      format.html { render json: reading_groups }
      format.json { render json: reading_groups }
    end
  end

  def save
    if params[:reading_group][:id].nil? || params[:reading_group][:id].to_i == 0
      params[:reading_group].delete(:id)
      response = KalibroConfiguration.request("reading_groups", {reading_group: params[:reading_group]})
    else
      path = "reading_groups/#{params[:reading_group][:id]}"
      params[:reading_group].delete(:id)
      response = KalibroConfiguration.request(path, {reading_group: params[:reading_group]}, :put)
    end

    response["reading_group"].delete("created_at")
    response["reading_group"].delete("updated_at")

    respond_to do |format|
      if response["reading_group"]["errors"].nil?
        format.json { render json: response["reading_group"] }
      else
        response["reading_group"]["kalibro_errors"] = response["reading_group"].delete("errors")
        format.json { render json: response["reading_group"], status: :unprocessable_entity }
      end
    end
  end

  def get
    reading_group = KalibroConfiguration.request("reading_groups/#{params[:id]}", {}, :get)

    respond_to do |format|
      if reading_group['error'].nil?
        format.json { render json: reading_group["reading_group"] }
      else
        format.json { render json: reading_group, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    KalibroConfiguration.request("reading_groups/#{params[:id]}", {}, :delete)

    respond_to do |format|
      format.json { render json: {}, status: :ok }
    end
  end
end
