class AddIndexToGitlabTrackingCommits < Rails.version < '5.1' ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]
  def change
    add_index :gitlab_tracking_commits, [:issue_id, :git_hash]
  end
end
