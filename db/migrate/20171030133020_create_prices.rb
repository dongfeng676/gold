class CreatePrices < ActiveRecord::Migration[5.1]
  def change
    create_table :prices do |t|
      t.float :price
      t.string :type

      t.timestamps
    end
  end
end
