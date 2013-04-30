class RemoveLocationFieldsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :location if User.column_names.include?('location')
    remove_column :users, :country if User.column_names.include?('country')
  end
end
