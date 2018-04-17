class FindStocksToUpdateJob
  @queue = :update

  def self.perform(*args)
    stocks = StockPrice.uniq.pluck(:ticker)
    
    stocks.each do |stock|
      Resque.enqueue(UpdateStockPriceJob,stock)
    end
  end
end
