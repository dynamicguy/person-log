class AddAvatarToUsers < ActiveRecord::Migration
  def change
    add_column :persons, :avatar, :string
  end
end
