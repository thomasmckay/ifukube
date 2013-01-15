class BugzillaBugHasManyAsyncJob < ActiveRecord::Migration
  def change
    add_column :async_jobs, :bugzilla_bug_id, :integer
    add_column :async_jobs, :user_id, :integer
  end
end
