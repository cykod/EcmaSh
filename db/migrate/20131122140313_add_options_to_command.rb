class AddOptionsToCommand < ActiveRecord::Migration
  def change
    add_column :commands, :opts, :string, array: true
  end
end
