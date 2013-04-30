class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.string :q
      t.integer :user_id
      t.string :ua

      t.timestamps
    end
  end
end
