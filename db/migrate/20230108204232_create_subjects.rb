class CreateSubjects < ActiveRecord::Migration[7.0]
  def change
    create_table :subjects do |t|
      t.string :name
      t.string :species
      t.string :content_hash

      t.index :name, unique: true
      t.index :species, unique: true

      t.timestamps
    end
  end
end
