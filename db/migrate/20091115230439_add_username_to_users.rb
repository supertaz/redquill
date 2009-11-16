class AddUsernameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string, :null => false, :default => ''
    add_index :users, [:username, :crypted_password, :password_salt], :named => "username_and_crypto_idx"
  end

  def self.down
    remove_column :users, :login
    remove_index :users, :name => :username_and_crypto_idx
  end
end
