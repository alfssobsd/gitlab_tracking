class CreateGitlabTrackingMergeRequest < ActiveRecord::Migration
  def change
    create_table :gitlab_tracking_merge_requests do |t|
      t.integer :issue_id
      t.integer :gitlab_id
      t.string :source
      t.string :target
      t.string :title

      t.string :state
      t.string :merge_status
      t.string :gitlab_url, :limit => 4096


      t.string :author_username
      t.string :author_name

      t.string :assignee_username
      t.string :assignee_name

      t.timestamp :timestamp
      
    end

    add_index :gitlab_tracking_merge_requests, [:issue_id, :gitlab_id]
  end
end
