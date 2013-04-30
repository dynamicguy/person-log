class CreateNewsletters < ActiveRecord::Migration
  def self.up
    create_table :newsletters do |t|
      t.string :subject
      t.datetime :delivered_at

      t.timestamps
    end
  end

  def self.down
    dop_table :newsletters
  end
end
