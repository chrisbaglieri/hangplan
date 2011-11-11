class AddPrivacyToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :privacy, :string, :null => false, :default => 'public'
    add_column :plans, :description, :text
  end
end
