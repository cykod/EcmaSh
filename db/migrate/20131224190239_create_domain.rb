class CreateDomain < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :name
      t.integer :directory_node_id
      t.integer :user_id
    end

    add_index :domains, :name 
    add_index :domains, :directory_node_id
  end
end
