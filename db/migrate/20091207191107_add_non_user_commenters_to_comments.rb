class AddNonUserCommentersToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :guest, :boolean, :null => false, :default => false
    add_column :comments, :guest_name, :string
    add_column :comments, :guest_email, :string
    add_column :comments, :guest_url, :string
  end

  def self.down
    remove_column :comments, :guest_url
    remove_column :comments, :guest_email
    remove_column :comments, :guest_name
    remove_column :comments, :guest
  end
end
