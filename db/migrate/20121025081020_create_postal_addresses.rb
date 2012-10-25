class CreatePostalAddresses < ActiveRecord::Migration
  def change
    create_table :postal_addresses do |t|
      t.string :name
      t.string :description
      t.string :email, :url, :faxNumber, :telephone, :country, :locality, :region, :postalCode, :postOfficeBoxNumber, :street

      t.timestamps
    end
  end
end
