class NrpSolution < ActiveRecord::Base
  belongs_to :nrp_execution
  serialize :solution_data, JSON

  validates :nrp_execution_id, presence: true
end
