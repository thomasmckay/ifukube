class AddCreatorFieldToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :creator, :string
  end
end
