class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :name
      t.text :description
      t.string :image
      t.references :gallery

      t.timestamps
    end
    add_index :images, :gallery_id
  end
end