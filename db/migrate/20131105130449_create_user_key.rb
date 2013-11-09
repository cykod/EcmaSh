class CreateUserKey < ActiveRecord::Migration
  def change
    create_table :user_keys do |t|
      t.references :user
      t.datetime :valid_until
      t.string :token
      t.inet :ip
      t.datetime :created_at
    end
  end
end
