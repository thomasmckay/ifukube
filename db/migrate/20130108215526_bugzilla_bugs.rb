class BugzillaBugs < ActiveRecord::Migration
  def up
    drop_table :tickets
    create_table :bugzilla_bugs do |t|
      t.string :number
      t.string :state
      t.string :system
      t.string :title
      t.string :description
      t.string :status
      t.string :project
      t.string :component
      t.string :priority
      t.string :severity
      t.string :assignee
      t.string :creator
      t.string :version
    end
  end

  def down
    drop_table :bugzilla_bugs
  end
end
