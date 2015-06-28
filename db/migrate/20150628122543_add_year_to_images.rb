class AddYearToImages < ActiveRecord::Migration
  def change
    add_column :images, :year, :int
    add_index  :images, :year
  end
end
