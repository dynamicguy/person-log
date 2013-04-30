class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :name
      t.text :summary
      t.date :start_date
      t.boolean :is_current
      t.integer :company_id, :limit => 8
      t.integer :user_id

      t.timestamps
    end
  end
end
