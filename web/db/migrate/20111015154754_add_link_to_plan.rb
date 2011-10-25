class AddLinkToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :link, :string
  end
end
