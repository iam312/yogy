class AddDeletedToImage < ActiveRecord::Migration
  def change
    add_column :images, :deleted, :int, default: 0
    add_index  :images, :deleted
  end
end
