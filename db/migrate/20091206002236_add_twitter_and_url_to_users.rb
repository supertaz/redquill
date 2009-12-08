class AddTwitterAndUrlToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :user_url, :string
    add_column :users, :twitter_username, :string
  end

  def self.down
    remove_column :users, :twitter_username
    remove_column :users, :user_url
  end
end
