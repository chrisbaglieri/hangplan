class AddUserToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :user_id, :integer
    add_index :plans, :user_id
  end
end
