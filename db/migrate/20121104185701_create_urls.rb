class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :title
      t.string :value
      t.integer :user_id

      t.timestamps
    end
  end
end
