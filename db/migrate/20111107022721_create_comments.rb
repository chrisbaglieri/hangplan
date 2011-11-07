class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :plan_id
      t.integer :user_id
      t.text :message

      t.timestamps
    end
    
    add_index :comments, :plan_id
  end
end
