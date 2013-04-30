class AddConfirmableToUsers < ActiveRecord::Migration
  def change
    add_column :users, :unconfirmed_email, :string unless User.column_names.include?("unconfirmed_email")
  end
end
