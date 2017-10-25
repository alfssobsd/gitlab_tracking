class GitlabTrackingController < ApplicationController
  unloadable
  skip_before_filter  :verify_authenticity_token
  skip_before_filter  :check_if_login_required

  def webhook_parsing
    body = JSON.parse(request.body.read)
    if body['object_kind'] == 'push'
      parse_push_hook(JSON.parse(request.body.read))
    elsif body['object_kind'] == 'merge_request'
      parse_merge_request_hook(body)
    end
    render status: 200, json: "OK".to_json
  end

  protected

  def parse_merge_request_hook(body)
    search_regexp = get_issue_regexp
    merge_request = body['object_attributes']
    author = body['user']
    match_regexp = merge_request['title'].gsub search_regexp
    if not match_regexp
      match_regexp = merge_request['source_branch'].gsub search_regexp
    end
    if not match_regexp
      match_regexp = merge_request['last_commit']['message'].gsub search_regexp
    end

    match_regexp.each do |issue_raw|
      issue_raw =~ /(?<issue_number>\d+)/
      begin
        issue = Issue.find(Regexp.last_match['issue_number'].to_i)
        GitlabTrackingMergeRequest.parse_merge_request_and_create(issue, merge_request, author)
      rescue ActiveRecord::RecordNotFound
        # ignored
      end
    end
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
