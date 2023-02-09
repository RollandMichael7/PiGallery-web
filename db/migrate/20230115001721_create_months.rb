class CreateMonths < ActiveRecord::Migration[7.0]
  def change
    create_table :months do |t|
      t.string :month
      t.integer :month_index
      t.integer :year

      t.timestamps
    end
  end
end
