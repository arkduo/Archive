class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :name
      t.string :genre
      t.string :zip
      t.integer :total
      t.timestamps null: false
    end
  end
end
