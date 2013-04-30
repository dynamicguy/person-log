class AddLatlonToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :lat, :decimal, :precision => 8, :scale => 2, :default => 0 unless User.column_names.include?('lat')
    add_column :users, :lon, :decimal, :precision => 8, :scale => 2, :default => 0 unless User.column_names.include?('lon')
  end

  def self.down
    remove_column :users, :lat
    remove_column :users, :lon
  end
end
