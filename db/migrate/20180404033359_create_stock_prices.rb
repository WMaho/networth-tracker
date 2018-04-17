class CreateStockPrices < ActiveRecord::Migration
  def change
    create_table :stock_prices do |t|
      t.string :ticker, null: false
      t.date :date, null: false
      t.float :price, null: false
      t.timestamps null: false
    end
  end
end
