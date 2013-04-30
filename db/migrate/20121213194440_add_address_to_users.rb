class AddAddressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :address, :string unless User.column_names.include?('address')
  end
end
