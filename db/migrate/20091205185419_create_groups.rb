class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name

      t.timestamps
    end
    add_index :groups, [:name, :id]
    add_index :groups, :id

    create_table :groups_users, :id => false do |t|
      t.integer       :group_id
      t.integer       :user_id
    end
    add_index :groups_users, [:group_id, :user_id]
    add_index :groups_users, [:user_id, :group_id]
  end

  def self.down
    drop_table :groups
    drop_table :groups_users
  end
end
