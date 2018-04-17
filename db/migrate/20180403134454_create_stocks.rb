class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.belongs_to :user, index: true
      t.string :ticker, null: false
      t.float :quantity, null: false
      t.date :buytime, null: false
      t.date :selltime, null: true
      t.timestamps null: false
    end
  end
end
