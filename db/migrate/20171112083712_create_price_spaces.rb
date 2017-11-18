class CreatePriceSpaces < ActiveRecord::Migration[5.1]
  def change
    create_table :price_spaces do |t|
      t.float :value

      t.timestamps
    end
  end
end
