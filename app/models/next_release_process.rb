class NextReleaseProcess < ActiveRecord::Base
  belongs_to :project

  has_many :nrp_related_issues, dependent: :destroy
  has_many :issues, through: :nrp_related_issues
  has_many :nrp_fuzzy_efforts, dependent: :destroy
  has_many :nrp_executions, dependent: :destroy

  validates :project_id, presence: true
  validates :status, inclusion: { in: %w[in_progress completed rejected] }

  scope :active, -> { where(status: 'in_progress') }
end
