class CreateEducations < ActiveRecord::Migration
  def self.up
    create_table :educations do |t|
      t.references :user
      t.string :school
      t.string :degree
      t.string :etype
      t.integer :year

      t.timestamps
    end
  end

  def self.down
    drop_table :educations
  end
end
