class AddStartAtToPlans < ActiveRecord::Migration
  def change
    remove_column :plans, :date
    add_column :plans, :start_at, :datetime
  end
end
