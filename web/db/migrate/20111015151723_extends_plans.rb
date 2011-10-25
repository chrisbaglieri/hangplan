class ExtendsPlans < ActiveRecord::Migration
  def up
    change_table :plans do |t|
      t.float :latitude
      t.float :longitude
      t.boolean :sponsored, :default => false
      t.boolean :tentative, :default => false
    end
  end

  def down
    remove_column :plans, :latitude
    remove_column :plans, :longitude
    remove_column :plans, :sponsored
    remove_column :plans, :tentative
  end
end
