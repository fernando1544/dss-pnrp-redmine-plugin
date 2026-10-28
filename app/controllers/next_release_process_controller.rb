class NextReleaseProcessController < ApplicationController
  before_action :find_next_release_process, only: [:show, :destroy, :reject] 
  before_action :find_project, only: [:new, :create] 
  before_action :find_project_from_nrp, only: [:show] 

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_project_from_nrp
    @project = NextReleaseProcess.find(params[:id]).project
  end

  def find_next_release_process
    @nrp = NextReleaseProcess.find(params[:id])
  end

  def show
    @nrpExecutions = NrpExecution.where(next_release_process_id: @nrp.id) rescue []
    @nrprIssues = NrpRelatedIssue.where(next_release_process_id: @nrp.id)
    @fuzzyEfforts = NrpFuzzyEffort.where(next_release_process_id: @nrp.id).index_by(&:issue_id)
  end

  def new
    active_process = NextReleaseProcess.where(project_id: @project.id, status: NextReleaseProcess::STATUS_IN_PROGRESS).first
    if active_process
      flash[:warning] = 'Ya existe un proceso de próximo lanzamiento en curso para este proyecto.'
      redirect_to next_release_process_path(active_process)
      return
    end

    @nrp = NextReleaseProcess.new(project_id: @project.id)
    @issues = Issue.find(@project.issue_ids)
  end

  def create
    issue_ids = params[:issues_ids] || []

    if issue_ids.empty?
      flash[:error] = 'Debe seleccionar al menos un requerimiento.'
      @project = Project.find(params[:project_id])
      @issues = Issue.find(@project.issue_ids)
      @nrp = NextReleaseProcess.new(project_id: @project.id)
      render :new
      return
    end

    ActiveRecord::Base.transaction do
      nrp = NextReleaseProcess.create!(
        project_id: @project.id,
        name: params[:name].presence || "Proceso de Próximo Lanzamiento",
        status: NextReleaseProcess::STATUS_IN_PROGRESS
      )
          
      issue_ids.each do |id|
        NrpRelatedIssue.create!(next_release_process_id: nrp.id, issue_id: id)
        NrpFuzzyEffort.create!(
          next_release_process_id: nrp.id, 
          issue_id: id, 
          e1: 0, 
          e2: 0, 
          e3: 0, 
          e4: 0
        )
      end
    end

    redirect_to(index_requeriment_engineering_path(project_id: @project.id))
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = "Error al crear el proceso: #{e.message}"
    @issues = Issue.find(@project.issue_ids)
    render :new
  end

  def reject
    rejection_reason = params[:rejection_reason] || 'Rechazado por el usuario'
    @nrp.update(status: NextReleaseProcess::STATUS_REJECTED, rejection_reason: rejection_reason)
    flash[:notice] = 'El proceso de próximo lanzamiento ha sido rechazado.'
    redirect_to(next_release_process_path(@nrp))
  end

  def destroy
    project_id = @nrp.project_id
    @nrp.destroy
    flash[:notice] = 'Proceso eliminado correctamente.'
    redirect_to(index_requeriment_engineering_path(project_id: project_id))
  end
end
