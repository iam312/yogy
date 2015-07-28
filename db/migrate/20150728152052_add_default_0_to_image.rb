class AddDefault0ToImage < ActiveRecord::Migration
  def up
    change_column :images, :like, :int, :default => 0
    change_column :images, :dislike, :int, :default => 0
    Image.where( {like: nil} ).update_all( like: 0 )
    Image.where( {dislike: nil} ).update_all( dislike: 0 )
  end

  def down
    change_column :images, :like, :int, :default => nil
    change_column :images, :dislike, :int, :default => nil
    Image.where( {like: 0} ).update_all( like: nil )
    Image.where( {dislike: 0} ).update_all( dislike: nil )
  end
end
