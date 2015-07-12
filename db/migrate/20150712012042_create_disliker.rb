class CreateDisliker < ActiveRecord::Migration
  def change
    create_table :dislikers do |t|
      t.integer :user_id
      t.integer :image_id
      t.timestamps
    end
    add_index :dislikers, [:user_id],  name: "dislikers_user_id_idx"
    add_index :dislikers, [:image_id], name: "dislikers_image_id_idx"
  end
end
