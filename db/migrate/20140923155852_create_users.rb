class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.boolean :enabled
      t.string :name
      t.string :image

      t.timestamps
    end
  end
end
