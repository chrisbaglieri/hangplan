class AddDeviseToUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
    end
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration   
  end
end
