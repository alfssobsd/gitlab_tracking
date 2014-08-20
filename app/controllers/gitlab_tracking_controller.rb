class GitlabTrackingController < ApplicationController
  unloadable
  skip_before_filter  :verify_authenticity_token
  skip_before_filter  :check_if_login_required

  def webhook_parsing
    parse_push_hook(JSON.parse(request.body.read))
    render status: 200, json: "OK".to_json
  end

  protected

  def parse_push_hook(body)
    search_regexp = get_issue_regexp
    branch = body['ref']
    body['commits'].each do |commit|
      match_regexp = commit['message'].gsub search_regexp
      match_regexp.each do |issue_raw|
        issue_raw =~ /(?<issue_number>\d+)/
        begin
          issue = Issue.find(Regexp.last_match['issue_number'].to_i)
          GitlabTrackingCommit.parse_commit_and_create(issue, branch, commit)
        rescue ActiveRecord::RecordNotFound
          # ignored
        end
      end
    end
  end

  def get_issue_regexp
    issue_regexp = Setting.plugin_gitlab_tracking['issue_regexp']
    issue_regexp_options = Setting.plugin_gitlab_tracking['issue_regexp_options']
    Regexp.new "#{issue_regexp}", "#{issue_regexp_options}"
  end
end
