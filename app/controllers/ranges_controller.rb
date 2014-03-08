class RangesController < ApplicationController
  def save
    range = KalibroGem::Entities::Range.new(params[:range])

    respond_to do |format|
      if range.save
        format.json { render json: range.to_hash }
      else
        format.json { render json: range.to_hash, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    begin
      range = KalibroGem::Entities::Range.find(params[:id])
      range.destroy
    rescue KalibroGem::Errors::RecordNotFound
      range = {error: 'RecordNotFound'}
    end

    respond_to do |format|
      if range.is_a?(KalibroGem::Entities::Range)
        format.json { render json: range.to_hash }
      else
        format.json { render json: range, status: :unprocessable_entity }
      end
    end
  end

  def of
    ranges = {ranges: KalibroGem::Entities::Range.ranges_of(params[:reading_id]).map { |range| range.to_hash }}

    respond_to do |format|
      format.json { render json: ranges }
    end
  end
end
