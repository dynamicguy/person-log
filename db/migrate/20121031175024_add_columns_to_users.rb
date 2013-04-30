class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bio, :text
    add_column :users, :gender, :string, :default => 'male'
    add_column :users, :location, :string
    add_column :users, :phone, :string
  end
end
