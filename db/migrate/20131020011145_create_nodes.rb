class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :name
      t.attachment :file
      t.string :file_type
      t.text :fullpath, limit: 512
      t.integer :parent_id
      t.integer :parent_ids, array: true
      t.string :type
      t.integer :user_id
      t.integer :lock_level, limit: 2, default: 1
      t.integer :width, limit: 2
      t.integer :height, limit: 2

      t.timestamps
    end

    add_index :nodes, :user_id
    add_index :nodes, :fullpath
  end
end
