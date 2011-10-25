class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :followed_user_id

      t.timestamps
    end
    
    add_index :subscriptions, :user_id
    add_index :subscriptions, :followed_user_id
  end
end
