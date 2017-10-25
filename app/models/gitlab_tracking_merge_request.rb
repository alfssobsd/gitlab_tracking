class GitlabTrackingMergeRequest < ActiveRecord::Base
  unloadable
  belongs_to :issue


  class << self

    def parse_merge_request_and_create(issue, merge_request, author)
      find_or_create_by(gitlab_id: merge_request['id']) do |gtmr|
        gtmr.issue = issue

        gtmr.source = merge_request['source_branch']
        gtmr.target = merge_request['target_branch']
        gtmr.title = merge_request['title']

        gtmr.state = merge_request['state']
        gtmr.merge_status = merge_request['merge_status']

        gtmr.gitlab_url = merge_request['url']

        gtmr.author_username = author['username']
        gtmr.author_name = author['name']

        gtmr.assignee_username = merge_request['assignee']['username']
        gtmr.assignee_name = merge_request['assignee']['name']

        gtmr.timestamp = Time.parse(merge_request['created_at'])
        gtmr.save
      end
    end
  end

end
