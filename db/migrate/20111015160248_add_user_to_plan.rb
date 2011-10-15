class AddUserToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :user_id, :integer
  end
end
