class ExtendsPlans < ActiveRecord::Migration
  def up
    change_table :plans do |t|
      t.float :latitude
      t.float :longitude
      t.boolean :sponsored
      t.boolean :tentative
    end
  end

  def down
    remove_column :plans, :latitude
    remove_column :plans, :longitude
    remove_column :plans, :sponsored
    remove_column :plans, :tentative
  end
end
