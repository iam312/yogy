class CreateYogies < ActiveRecord::Migration
  def change
    create_table :yogies do |t|
      t.string :title
      t.integer :user_id
      t.integer :image_id
      t.string :address
      t.integer :x
      t.integer :y
      t.text :desc

      t.timestamps
    end
  end
end
