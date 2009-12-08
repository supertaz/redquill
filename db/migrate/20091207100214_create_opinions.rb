class CreateOpinions < ActiveRecord::Migration
  def self.up
    create_table :opinions do |t|
      t.integer :user_id , :null => false, :default => 0
      t.integer :comment_id, :null => false, :default => 0
      t.boolean :agreed, :null => false, :default => true

      t.timestamps
    end
    add_index :opinions, [:user_id, :comment_id], :unique => true
    add_index :opinions, [:comment_id, :user_id, :agreed]
  end

  def self.down
    drop_table :opinions
  end
end
