class CreateAsyncJobs < ActiveRecord::Migration
  def change
    create_table :async_jobs do |t|
      t.string :sidekiq

      t.timestamps
    end
  end
end
