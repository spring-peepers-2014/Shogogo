class Users < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :phone_number
      t.string :password_digest
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
