class ProjectsController < ApplicationController
  def exists
    respond_to do |format|
      format.json { render json: KalibroProcessor.request("projects/#{params[:id]}/exists", {}, :get) }
    end
  end

  def all
    projects = KalibroProcessor.request("projects", {}, :get)

    respond_to do |format|
      format.html { render json: projects }
      format.json { render json: projects }
    end
  end

  # In the future, this method should get splitted according to https://www.pivotaltracker.com/story/show/75394662
  def save
    if !params['project']['id'].nil? && params['project']['id'].to_i != 0 && KalibroProcessor.request("projects/#{params['project']['id']}/exists", {}, :get)['exists']
      response = KalibroProcessor.request("projects/#{params['project']['id']}", {'project' => params['project']}, :put)
    else
      response = KalibroProcessor.request("projects", {'project' => params['project']}) # Justs send projects instead of all the params
    end

    respond_to do |format|
      if response['project']['errors'].nil?
        format.json { render json: response['project'] }
      else
        format.json { render json: response['project'], status: :unprocessable_entity }
      end
    end
  end

  def get
    response = KalibroProcessor.request("projects/#{params[:id]}", {}, :get)

    respond_to do |format|
      if response["error"].nil?
        # KalibroGatekeeperClient does not expects these fields
        response["project"].delete("created_at")
        response["project"].delete("updated_at")

        format.json { render json: response["project"] }
      else
        format.json { render json: response, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    response = KalibroProcessor.request("projects/#{params[:id]}", {}, :delete)

    respond_to do |format|
      format.json { render json: response }
    end
  end
end
