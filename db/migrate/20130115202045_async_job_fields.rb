class AsyncJobFields < ActiveRecord::Migration
  def change
    add_column :async_jobs, :action, :string
    add_column :async_jobs, :updated_attributes, :text
  end
end
