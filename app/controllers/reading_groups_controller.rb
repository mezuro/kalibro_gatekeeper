class ReadingGroupsController < ApplicationController
  def exists
    exists = { exists: KalibroGem::Entities::ReadingGroup.exists?(params[:id]) }

    respond_to do |format|
      format.json { render json: exists }
    end
  end

  def all
    reading_groups = {reading_groups: KalibroGem::Entities::ReadingGroup.all.map { |reading_group| reading_group.to_hash }}

    respond_to do |format|
      format.html { render json: reading_groups }
      format.json { render json: reading_groups }
    end
  end

  def save
    reading_group = KalibroGem::Entities::ReadingGroup.new(params[:reading_group])

    respond_to do |format|
      if reading_group.save
        format.json { render json: reading_group.to_hash }
      else
        format.json { render json: reading_group.to_hash, status: :unprocessable_entity }
      end
    end
  end

  def get
    begin
      reading_group = KalibroGem::Entities::ReadingGroup.find(params[:id])
    rescue KalibroGem::Errors::RecordNotFound
      reading_group = {error: 'RecordNotFound'}
    end

    respond_to do |format|
      if reading_group.is_a?(KalibroGem::Entities::ReadingGroup)
        format.json { render json: reading_group.to_hash }
      else
        format.json { render json: reading_group, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    begin
      reading_group = KalibroGem::Entities::ReadingGroup.find(params[:id])
      reading_group.destroy
    rescue KalibroGem::Errors::RecordNotFound
      reading_group = {error: 'RecordNotFound'}
    end

    respond_to do |format|
      if reading_group.is_a?(KalibroGem::Entities::ReadingGroup)
        format.json { render json: reading_group.to_hash }
      else
        format.json { render json: reading_group, status: :unprocessable_entity }
      end
    end
  end
end
