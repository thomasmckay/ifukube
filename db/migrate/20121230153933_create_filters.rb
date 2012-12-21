class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.string :name
      t.text :filter
      t.text :fields

      t.timestamps
    end
  end
end
