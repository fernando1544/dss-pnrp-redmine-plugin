class NrpRelatedIssue < ActiveRecord::Base
  belongs_to :next_release_process
  belongs_to :issue

  validates :next_release_process_id, presence: true
  validates :issue_id, presence: true, uniqueness: { scope: :next_release_process_id }
end
