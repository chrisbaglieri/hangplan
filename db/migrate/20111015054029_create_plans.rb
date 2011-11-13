class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name, :null => false
      t.text :description
      t.string :location
      t.float :latitude
      t.float :longitude
      t.string :link
      t.string :privacy, :string, :null => false, :default => 'public'
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :tentative, :default => false
      t.timestamps
    end
    add_index :plans, :name
  end
end
