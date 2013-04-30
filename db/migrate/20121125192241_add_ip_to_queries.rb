class AddIpToQueries < ActiveRecord::Migration
  def change
    add_column :queries, :ip, :string
  end
end
