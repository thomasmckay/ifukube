class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :ticket_system
      t.string :number
      t.string :title
      t.string :status

      t.timestamps
    end
  end
end
