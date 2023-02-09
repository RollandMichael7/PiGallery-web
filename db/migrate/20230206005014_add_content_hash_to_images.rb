class AddContentHashToImages < ActiveRecord::Migration[7.0]
  def change
    add_column :images, :content_hash, :string
  end
end
