class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.string :location
      t.datetime :time

      t.timestamps
    end
  end
end
