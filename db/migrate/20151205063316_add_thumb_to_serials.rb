class AddThumbToSerials < ActiveRecord::Migration
  def change
    add_column :serials, :thumb, :string
  end
end
