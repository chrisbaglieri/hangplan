class DropSubscriptions < ActiveRecord::Migration
  def up
    drop_table :subscriptions
  end

  def down
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :followed_user_id
      t.timestamps
    end
    add_index :subscriptions, :user_id
    add_index :subscriptions, :followed_user_id
  end
end
