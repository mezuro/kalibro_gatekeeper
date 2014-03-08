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

  def of
    repositories = {repositories: KalibroGem::Entities::Repository.repositories_of(params[:project_id]).map { |repository| repository.to_hash }}

    respond_to do |format|
      format.json { render json: repositories }
    end
  end

  def process_repository
    KalibroGem::Entities::Repository.find(params[:id]).process

    respond_to do |format|
      format.json { render json: {processing: params[:id]} }
    end
  end

  def cancel_process
    KalibroGem::Entities::Repository.find(params[:id]).cancel_process

    respond_to do |format|
      format.json { render json: {canceled_processing_for: params[:id]} }
    end
  end

  def supported_types
    types = {supported_types: KalibroGem::Entities::Repository.repository_types}

    respond_to do |format|
      format.json { render json: types }
    end
  end
end
