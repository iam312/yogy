class AddViewCountToImage < ActiveRecord::Migration
  def change
    add_column :images, :view_count, :int, default: 0
    add_index  :images, :view_count
  end
end
