class CreateSerials < ActiveRecord::Migration
  def change
    create_table :serials do |t|
      t.string :series
      t.integer :volume
      t.timestamps null: false
    end
  end
end
