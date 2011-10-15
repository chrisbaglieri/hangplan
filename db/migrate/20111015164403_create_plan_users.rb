class CreatePlanUsers < ActiveRecord::Migration
  def self.up
    create_table :plans_users, :id => false do |t|
      t.integer :plan_id
      t.integer :user_id
    end
    add_index :plans_users, :plan_id, :name => 'plans_users_plan_id'
    add_index :plans_users, :user_id, :name => 'plans_users_user_id'
  end

  def self.down
    drop_table :plans_users
  end
end
