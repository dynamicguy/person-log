class CreateUsersFriendsJoinTable < ActiveRecord::Migration
  def change
    create_table :users_friends, :id => false do |t|
      t.integer :user_id
      t.integer :friend_id
    end
  end
end
