include GitlabTrackingHelper

module GitlabTracking
  class Hooks < Redmine::Hook::ViewListener
    def view_issues_show_description_bottom(context={ })

      context[:gtc_commit_list] = GitlabTrackingCommit.where(issue_id: context[:issue]).order('id')
      context[:controller].send(:render_to_string, {
          :partial => "hooks/gitlab_tracking/view_issues_show_description_bottom",
          :locals => context
      })
    end
  end
end