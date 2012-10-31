class AddLatLongToUsers < ActiveRecord::Migration
  def change
    add_column :persons, :lat, :double
    add_column :persons, :lon, :double
  end
end
