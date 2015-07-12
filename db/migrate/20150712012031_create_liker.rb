class CreateLiker < ActiveRecord::Migration
  def change
    create_table :likers do |t|
      t.integer :user_id
      t.integer :image_id
      t.timestamps
    end
    add_index :likers, [:user_id],  name: "likers_user_id_idx"
    add_index :likers, [:image_id], name: "likers_image_id_idx"
  end
end
