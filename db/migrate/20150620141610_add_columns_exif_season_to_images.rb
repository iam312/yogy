class AddColumnsExifSeasonToImages < ActiveRecord::Migration
  def change
    add_column :images, :exif, :text
    add_column :images, :season, :int
    add_index  :images, :season
  end
end
