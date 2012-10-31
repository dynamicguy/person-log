class AddLastNameToUsers < ActiveRecord::Migration
  def change
    add_column :persons, :last_name, :string
  end
end
