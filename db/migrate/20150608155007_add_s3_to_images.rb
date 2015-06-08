class AddS3ToImages < ActiveRecord::Migration
  def change
    add_column :images, :s3, :string
  end
end
