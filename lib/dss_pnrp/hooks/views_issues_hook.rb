module DssPnrp
  module Hooks
    class ViewsIssuesHook < Redmine::Hook::ViewListener
      def view_issues_show_details_bottom(context = {})
        html = context[:controller].send(:render_to_string, partial: 'issues/criteria_issue', locals: context)
        html << context[:controller].send(:render_to_string, partial: 'issues/fuzzy_effort', locals: context)
        html.html_safe
      end

      def view_issues_form_details_bottom(context = {})
        html = context[:controller].send(:render_to_string, partial: 'issues/criteria_issue_form', locals: context)
        html << context[:controller].send(:render_to_string, partial: 'issues/fuzzy_effort_form', locals: context)
        html.html_safe
      end
    end
  end
end