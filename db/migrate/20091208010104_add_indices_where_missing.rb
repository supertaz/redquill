class AddIndicesWhereMissing < ActiveRecord::Migration
  def self.up
    add_index :roles_users, [:role_id, :user_id]
    add_index :roles_users, [:user_id, :role_id]
    add_index :posts, :local_date
    add_index :roles, [:id, :name]
    add_index :roles, [:name, :id]
  end

  def self.down
  end
end
