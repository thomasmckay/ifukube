class FixTicketColumnNameStatusToState < ActiveRecord::Migration
  def up
    rename_column :tickets, :status, :state
  end

  def down
    rename_column :tickets, :state, :status
  end
end
