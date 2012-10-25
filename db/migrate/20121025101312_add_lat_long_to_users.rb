class AddLatLongToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lat, :double
    add_column :users, :lon, :double
  end
end
