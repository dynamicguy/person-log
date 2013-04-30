class AddMaritalStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :marital_status, :string, :default => :single
  end
end
