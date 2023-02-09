class AddMonthToImages < ActiveRecord::Migration[7.0]
  def change
    add_reference :images, :month, foreign_key: true
  end
end
