class RequerimentEngineeringController < ApplicationController
  before_action :find_project, only: [:index] 

  def index
    @pps = PrioritizationProcess.where(project_id: @project['id'])  
    @nrps = NextReleaseProcess.where(project_id: @project['id'])  
  end

  def find_project
    @project = Project.find(params[:project_id])
  end
end
