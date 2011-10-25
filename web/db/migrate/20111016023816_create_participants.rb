class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.integer :user_id
      t.integer :plan_id
      t.integer :points, :default => 0

      t.timestamps
    end
    
    add_index :participants, :user_id
    add_index :participants, :plan_id
  end
end
