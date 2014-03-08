class RepositoriesController < ApplicationController
  def save
    repository = KalibroGem::Entities::Repository.new(params[:repository])

    respond_to do |format|
      if repository.save
        format.json { render json: repository.to_hash }
      else
        format.json { render json: repository.to_hash, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    begin
      repository = KalibroGem::Entities::Repository.find(params[:id])
      repository.destroy
    rescue KalibroGem::Errors::RecordNotFound
      repository = {error: 'RecordNotFound'}
    end

    respond_to do |format|
      if repository.is_a?(KalibroGem::Entities::Repository)
        format.json { render json: repository.to_hash }
      else
        format.json { render json: repository, status: :unprocessable_entity }
      end
    end
  end
end
