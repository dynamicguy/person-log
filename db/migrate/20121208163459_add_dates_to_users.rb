class AddDatesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :birthday, :date unless User.column_names.include?('birthday')
    add_column :users, :deathday, :date unless User.column_names.include?('deathday')
    add_column :users, :birthplace, :string unless User.column_names.include?('birthplace')
    add_column :users, :country, :string unless User.column_names.include?('country')
    add_column :users, :location, :string unless User.column_names.include?('location')
  end
end
