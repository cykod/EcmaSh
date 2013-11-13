class CreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :username,           :null => false, :default => ""
      t.string :password_digest,    :null => false, :default => ""
      t.string :email

      t.timestamps
    end

    add_index :users, :username,   :unique => true
  end
end
