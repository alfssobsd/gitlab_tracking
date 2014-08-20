require 'redmine'


Redmine::Plugin.register :gitlab_tracking do
  name 'Gitlab Tracking plugin'
  author 'Sergey Kravchuk'
  description 'Tracking gitlab activity repo'
  version '1.4'
  url 'https://github.com/alfss/gitlab_tracking'
  author_url 'http://alfss.net'

  settings(:partial => 'settings/gitlab_tracking_settings',
           :default => {
               'issue_regexp' => '((fix|ref)\s*#?[0-9]+)',
               'issue_regexp_options' => 'i'
           })
end

require_dependency 'gitlab_tracking/hooks'