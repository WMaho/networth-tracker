class CreatePriceUpdates < ActiveRecord::Migration
  def change
    create_table :price_updates do |t|
      t.string :ticker, null: false
      t.boolean :updating, null: false, default: false
      t.timestamps null: false
    end
  end
end
