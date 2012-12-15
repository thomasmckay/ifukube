class FixTicketColumnNameSystem < ActiveRecord::Migration
  def up
    rename_column :tickets, :ticket_system, :system
  end

  def down
    rename_column :tickets, :system, :ticket_system
  end
end
