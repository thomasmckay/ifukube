class AddProjectFieldsToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :project, :string
    add_column :tickets, :component, :string
    add_column :tickets, :priority, :string
    add_column :tickets, :assignee, :string
  end
end
