class NrpFuzzyEffort < ActiveRecord::Base
  belongs_to :next_release_process
  belongs_to :issue

  validates :e1, :e2, :e3, :e4, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :validate_fuzzy_bounds

  private

  def validate_fuzzy_bounds
    return if e1.blank? || e2.blank? || e3.blank? || e4.blank?

    if e1 > e2 || e2 > e3 || e3 > e4
      errors.add(:base, "Los valores difusos deben cumplir la condición: e1 <= e2 <= e3 <= e4")
    end
  end
end
