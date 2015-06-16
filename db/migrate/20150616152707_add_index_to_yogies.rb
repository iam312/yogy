class AddIndexToYogies < ActiveRecord::Migration
  def change
    add_index :yogies, :title
    add_index :yogies, :created_at
  end
end
