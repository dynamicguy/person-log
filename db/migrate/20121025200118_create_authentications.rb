class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.text :raw
      t.text :credentials

      t.timestamps
    end
  end
end
