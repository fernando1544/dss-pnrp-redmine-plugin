module DssPnrp
  module Patches
    module IssuesControllerPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          before_action :save_before_state, only: [:update]
        end
      end

      module InstanceMethods
        def save_before_state
          if params[:pp_criteria_issue].present?
            params[:pp_criteria_issue].each do |criteria|
              updated_criteria = PpCriteriaIssue.find_by(id: criteria[0])
              updated_criteria.update(value: criteria[1]['value']) if updated_criteria
            end
          end

          if params[:nrp_fuzzy_effort].present? && @issue.present?
            fuzzy_data = params[:nrp_fuzzy_effort]
            process_id = fuzzy_data[:next_release_process_id]

            if process_id.present?
              effort = NrpFuzzyEffort.find_or_initialize_by(
                next_release_process_id: process_id,
                issue_id: @issue.id
              )

              effort.assign_attributes(
                e1: fuzzy_data[:e1].to_f,
                e2: fuzzy_data[:e2].to_f,
                e3: fuzzy_data[:e3].to_f,
                e4: fuzzy_data[:e4].to_f,
                real_effort: fuzzy_data[:real_effort].present? ? fuzzy_data[:real_effort].to_f : effort.real_effort
              )
              effort.save
            end
          end
        end
      end
    end
  end
end

unless IssuesController.included_modules.include?(DssPnrp::Patches::IssuesControllerPatch)
  IssuesController.send(:include, DssPnrp::Patches::IssuesControllerPatch)
end
