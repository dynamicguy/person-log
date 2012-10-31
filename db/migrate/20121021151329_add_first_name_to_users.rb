class AddFirstNameToUsers < ActiveRecord::Migration
  def change
    add_column :persons, :first_name, :string
  end
end
