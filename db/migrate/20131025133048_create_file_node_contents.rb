class CreateFileNodeContents < ActiveRecord::Migration
  def change
    create_table :file_node_contents do |t|
      t.text :content
      t.references :file_node
      t.string :content_type

      t.timestamps
    end
  end
end
