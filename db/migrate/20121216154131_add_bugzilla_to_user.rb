class AddBugzillaToUser < ActiveRecord::Migration
  def change
    add_column :users, :bugzilla_email, :string
    add_column :users, :bugzilla_password, :string
  end
end
