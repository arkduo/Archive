class AddThumbToBooks < ActiveRecord::Migration
  def change
    add_column :books, :thumb, :string
  end
end
