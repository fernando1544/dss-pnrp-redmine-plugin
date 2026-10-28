class NextReleaseProcess < ActiveRecord::Base
  belongs_to :project
  has_many :nrp_related_issues, dependent: :destroy
  has_many :issues, through: :nrp_related_issues
  has_many :nrp_fuzzy_efforts, dependent: :destroy
  has_many :nrp_executions, dependent: :destroy

  STATUS_IN_PROGRESS = 'in_progress'
  STATUS_FINISHED    = 'finished'
  STATUS_REJECTED    = 'rejected'

  def in_progress?
    status == STATUS_IN_PROGRESS
  end

  def finished?
    status == STATUS_FINISHED
  end

  def rejected?
    status == STATUS_REJECTED
  end

  def human_status
    case status
    when STATUS_IN_PROGRESS then 'En curso'
    when STATUS_FINISHED    then 'Finalizado'
    when STATUS_REJECTED    then 'Rechazado'
    else status.to_s.humanize
    end
  end
end
