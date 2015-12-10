class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.integer :serial_id
      t.string :title
      t.string :genre
      t.string :zip
      t.integer :total
      t.string :thumb
      t.timestamps null: false
    end
  end
end
