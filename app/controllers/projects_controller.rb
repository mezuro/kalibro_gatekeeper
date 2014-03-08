class ProjectsController < ApplicationController
  def exists
    exists = { exists: KalibroGem::Entities::Project.exists?(params[:id]) }

    respond_to do |format|
      format.json { render json: exists }
    end
  end

  def all
    projects = {projects: KalibroGem::Entities::Project.all.map { |project| project.to_hash }}

    respond_to do |format|
      format.html { render json: projects }
      format.json { render json: projects }
    end
  end

  def save
    project = KalibroGem::Entities::Project.new(params[:project])

    respond_to do |format|
      if project.save
        format.json { render json: project.to_hash }
      else
        format.json { render json: project.to_hash, status: :unprocessable_entity }
      end
    end
  end

  def get
    begin
      project = KalibroGem::Entities::Project.find(params[:id])
    rescue KalibroGem::Errors::RecordNotFound
      project = {error: 'RecordNotFound'}
    end

    respond_to do |format|
      if project.is_a?(KalibroGem::Entities::Project)
        format.json { render json: project.to_hash }
      else
        format.json { render json: project, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    begin
      project = KalibroGem::Entities::Project.find(params[:id])
      project.destroy
    rescue KalibroGem::Errors::RecordNotFound
      project = {error: 'RecordNotFound'}
    end

    respond_to do |format|
      if project.is_a?(KalibroGem::Entities::Project)
        format.json { render json: project.to_hash }
      else
        format.json { render json: project, status: :unprocessable_entity }
      end
    end
  end
end
