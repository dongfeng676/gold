class CreateUserPriceReminds < ActiveRecord::Migration[5.1]
  def change
    create_table :user_price_reminds do |t|
      t.integer :user_id
      t.integer :price_space_id

      t.timestamps
    end
  end
end
