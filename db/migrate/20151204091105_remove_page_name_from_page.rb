class RemovePageNameFromPage < ActiveRecord::Migration
  def change
    remove_column :pages, :page_name, :string
  end
end
