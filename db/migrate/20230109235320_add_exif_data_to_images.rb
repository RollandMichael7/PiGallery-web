class AddExifDataToImages < ActiveRecord::Migration[7.0]
  def change
    add_column :images, :date_taken, :datetime
    add_column :images, :camera_body, :string
    add_column :images, :focal_length, :decimal
    add_column :images, :aperture, :decimal
    add_column :images, :shutter, :decimal
    add_column :images, :iso, :integer
  end
end
