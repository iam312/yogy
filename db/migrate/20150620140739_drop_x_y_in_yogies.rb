class DropXYInYogies < ActiveRecord::Migration
  def up
    remove_column :yogies, :x
    remove_column :yogies, :y
  end

  def down
    add_column :images, :x, :int
    add_column :images, :y, :int
  end
end
