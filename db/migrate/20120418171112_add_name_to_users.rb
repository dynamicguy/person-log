class AddNameToUsers < ActiveRecord::Migration
  def change
    add_column :persons, :name, :string
  end
end
