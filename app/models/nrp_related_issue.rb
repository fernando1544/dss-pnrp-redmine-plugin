class NrpRelatedIssue < ActiveRecord::Base
  belongs_to :next_release_process
  belongs_to :issue
end
