class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :industry
      t.string :name
      t.text :description
      t.string :location
      t.string :size
      t.string :ctype

      t.timestamps
    end
  end
end
