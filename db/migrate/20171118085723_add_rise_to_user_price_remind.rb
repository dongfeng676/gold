class AddRiseToUserPriceRemind < ActiveRecord::Migration[5.1]
  def change
    add_column :user_price_reminds, :rise, :boolean
  end
end
