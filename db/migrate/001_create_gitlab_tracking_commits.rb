class CreateGitlabTrackingCommits < ActiveRecord::Migration
  def change
    create_table :gitlab_tracking_commits do |t|
      t.integer :issue_id
      t.string :git_hash
      t.string :author_name
      t.string :author_email
      t.text :message
      t.string :branch
      t.string :gitlab_url, :limit => 4096
      t.timestamp :timestamp
    end

    add_index :gitlab_tracking_commits, :issue_id
  end
end
