class DropPlanTimeInFavorOfDate < ActiveRecord::Migration
  def up
    remove_column :plans, :time
    add_column :plans, :date, :date
  end

  def down
    remove_column :plans, :date
    add_column :plans, :time, :date
  end
end
