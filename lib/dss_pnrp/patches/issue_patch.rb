require_dependency 'issue'

module DssPnrp
  module Patches
    module IssuePatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          has_many :pp_criteria_issues
          has_many :nrp_related_issues, dependent: :destroy
          has_many :next_release_processes, through: :nrp_related_issues
          has_many :nrp_fuzzy_efforts, dependent: :destroy
        end
      end

      module InstanceMethods
        def nrp_fuzzy_effort_for(process)
          return nil unless process
          process_id = process.is_a?(NextReleaseProcess) ? process.id : process
          nrp_fuzzy_efforts.find_by(next_release_process_id: process_id)
        end

        def active_next_release_process
          NextReleaseProcess.where(project_id: project_id, status: 'in_progress').first
        end
      end
    end
  end
end

unless Issue.included_modules.include?(DssPnrp::Patches::IssuePatch)
  Issue.send(:include, DssPnrp::Patches::IssuePatch)
end
