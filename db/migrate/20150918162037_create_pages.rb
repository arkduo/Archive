class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer  :book_id
      t.string    :pict
      t.timestamps null: false
    end
  end
end
