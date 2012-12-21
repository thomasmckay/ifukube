class AddVersionSeverityFieldsToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :version, :string
    add_column :tickets, :severity, :string
  end
end
