class Commands < ActiveRecord::Migration
  def change
    create_table :commands do |t|
      t.references :user
      t.string :type
      t.string :argv, array: true
      t.boolean :successful
      t.timestamps
    end
  end
end
