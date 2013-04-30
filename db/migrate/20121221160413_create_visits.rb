class CreateVisits < ActiveRecord::Migration
  def change
    if Visit.columns.length < 1
      create_table :visits do |t|
        t.references :user
        t.string :ip
        t.string :ua
        t.datetime :created
      end
    end
  end
end
