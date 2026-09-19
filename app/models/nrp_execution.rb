class NrpExecution < ActiveRecord::Base
  belongs_to :next_release_process
  has_many :nrp_solutions, dependent: :destroy

  validates :p1, :p2, :p3, :p4, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: %w[pending running completed failed] }
  validate :validate_budget_bounds

  private

  def validate_budget_bounds
    return if p1.blank? || p2.blank? || p3.blank? || p4.blank?

    if p1 > p2 || p2 > p3 || p3 > p4
      errors.add(:base, "El presupuesto difuso debe cumplir: p1 <= p2 <= p3 <= p4")
    end
  end
end