class CreatePlaces < ActiveRecord::Migration

  def change
    create_table :places do |t|
      t.string :name
      t.string :description
      t.timestamps

      #t.column :shape, :geometry  # or t.geometry :shape
      #t.line_string :path, :srid => 3785
      #t.point :latlon, :geographic => true
      #add_index :latlon, :spatial => true

    end
  end
end
