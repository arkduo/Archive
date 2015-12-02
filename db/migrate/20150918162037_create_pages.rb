class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer  :book_id
      t.string    :page_image
      t.string    :page_name
      t.timestamps null: false
    end
  end
end
