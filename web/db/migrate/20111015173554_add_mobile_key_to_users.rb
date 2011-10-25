class AddMobileKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mobile_key, :string
    add_index :users, :mobile_key
  end
end
