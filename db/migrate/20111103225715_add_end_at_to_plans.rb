class AddEndAtToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :end_at, :datetime
    add_index :plans, :start_at
  end
end
