class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :title
      t.integer :user_id
      t.string :asset
      t.string :yogies
      t.text :desc
      t.timestamps
    end
  end
end
