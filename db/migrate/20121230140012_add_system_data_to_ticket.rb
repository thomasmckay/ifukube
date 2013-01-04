class AddSystemDataToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :system_data, :text
  end
end
