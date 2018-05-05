class UpdateStockPriceJob
  @queue = :update
  require 'net/http'
  require 'json'

  def self.perform(tick)
    # Do something later
    uri = URI("https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=#{tick}&outputsize=full&apikey=#{ENV['api_key']}")
    res = Net::HTTP.get(uri)
    data = JSON.parse(res)
    data["Time Series (Daily)"].each do |d|
      if(!StockPrice.find_by(ticker: tick, date:d.first))
        StockPrice.create(ticker: tick, date: d.first, price: d.second["5. adjusted close"].to_f)
      end
    end
  end
end
