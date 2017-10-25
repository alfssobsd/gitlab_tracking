require 'redmine'


Redmine::Plugin.register :gitlab_tracking do
  name 'Gitlab Tracking plugin'
  author 'Sergey Kravchuk'
  description 'Tracking gitlab activity repo'
  version '1.5'
  url 'https://github.com/alfss/gitlab_tracking'
  author_url 'http://alfss.net'

  settings(:partial => 'settings/gitlab_tracking_settings',
           :default => {
               'issue_regexp' => '((fix|ref)\s*#?[0-9]+)',
               'issue_regexp_options' => 'i',
               'push_hook_enabled' => true,
               'merge_request_hook_enabled' => true,
               'assign_users' => true,
           })
end

require_dependency 'gitlab_tracking/hooks'
