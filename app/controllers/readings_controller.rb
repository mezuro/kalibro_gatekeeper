class ReadingsController < ApplicationController
  def save
    reading = KalibroGem::Entities::Reading.new(params[:reading])

    respond_to do |format|
      if reading.save
        format.json { render json: reading.to_hash }
      else
        format.json { render json: reading.to_hash, status: :unprocessable_entity }
      end
    end
  end

  def get
    begin
      reading = KalibroGem::Entities::Reading.find(params[:id])
    rescue KalibroGem::Errors::RecordNotFound
      reading = {error: 'RecordNotFound'}
    end

    respond_to do |format|
      if reading.is_a?(KalibroGem::Entities::Reading)
        format.json { render json: reading.to_hash }
      else
        format.json { render json: reading, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    begin
      reading = KalibroGem::Entities::Reading.find(params[:id])
      reading.destroy
    rescue KalibroGem::Errors::RecordNotFound
      reading = {error: 'RecordNotFound'}
    end

    respond_to do |format|
      if reading.is_a?(KalibroGem::Entities::Reading)
        format.json { render json: reading.to_hash }
      else
        format.json { render json: reading, status: :unprocessable_entity }
      end
    end
  end

  def of
    readings = {readings: KalibroGem::Entities::Reading.readings_of(params[:reading_group_id]).map do |reading|
                    reading.group_id = params[:reading_group_id]
                    reading.to_hash
                  end
                }

    respond_to do |format|
      format.json { render json: readings }
    end
  end
end
