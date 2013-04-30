class AddPublishedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :published, :boolean, :default => false unless User.column_names.include?('published')
    add_column :users, :featured, :boolean, :default => false unless User.column_names.include?('featured')
    add_column :users, :published_at, :datetime unless User.column_names.include?('published_at')
  end

  def self.down
    remove_column :users, :published
    remove_column :users, :featured
    remove_column :users, :published_at
  end
end
