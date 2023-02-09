class AddImportToImages < ActiveRecord::Migration[7.0]
  def change
    add_reference :images, :import, null: false, foreign_key: true
  end
end
