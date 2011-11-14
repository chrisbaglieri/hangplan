class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string :source
      t.string :identifier
      t.string :access_token
      t.integer :user_id
      t.timestamps
    end
    add_index :identities, :source
    add_index :identities, :user_id
  end
end
