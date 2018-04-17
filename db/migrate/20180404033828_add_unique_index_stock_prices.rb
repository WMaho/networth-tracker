class AddUniqueIndexStockPrices < ActiveRecord::Migration
  def change
    add_index :stock_prices, [:ticker,:date], unique: true
  end
end
