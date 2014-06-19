class Artists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name, null: false
      t.integer :seatgeek_id, null: false

      t.timestamps
    end
  end
end