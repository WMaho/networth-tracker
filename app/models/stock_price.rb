class StockPrice < ActiveRecord::Base
    validates :ticker, uniqueness: { scope: :date }
end
