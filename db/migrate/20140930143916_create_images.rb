class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :title
      t.integer :yogy_id
      t.string :asset

      t.timestamps
    end
  end
end
