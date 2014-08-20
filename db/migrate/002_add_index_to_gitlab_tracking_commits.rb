class AddIndexToGitlabTrackingCommits < ActiveRecord::Migration
  def change
    add_index :gitlab_tracking_commits, [:issue_id, :git_hash]
  end
end