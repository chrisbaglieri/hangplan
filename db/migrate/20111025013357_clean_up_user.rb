class CleanUpUser < ActiveRecord::Migration
  def up
    remove_column :users, :mobile_key
  end

  def down
    add_column :users, :mobile_key, :string
  end
end
