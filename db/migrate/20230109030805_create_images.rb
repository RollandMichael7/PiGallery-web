class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images do |t|
      t.string :app_path
      t.string :name_detail
      t.references :subject, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true

      t.index :app_path, unique: true

      t.timestamps
    end
  end
end
