class AddOauthIndexToUsers < ActiveRecord::Migration
  def self.up
    add_index :users, :oauth_token, :unique => true
  end

  def self.down
  end
end
