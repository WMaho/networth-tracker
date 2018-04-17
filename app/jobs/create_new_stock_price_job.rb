class CreateNewStockPriceJob #< ActiveJob::Base
  @queue = :create
  #queue_as :create
  require 'net/http'
  
  def self.perform(tick)
    #Stock.create(user_id: 1, ticker: "Triggered anyway", date: Date.today, quantity: 3)
    if(!StockPrice.find_by(ticker: tick))
      #Stock.create(user_id: 1, ticker: "should have triggered",date: Date.today,quantity: 1)
      uri = URI("https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=#{tick}&outputsize=full&apikey=6E5BNXSBW9QWCJHY")
      res = Net::HTTP.get(uri)
      data = JSON.parse(res)
      data["Time Series (Daily)"].each do |d|
        StockPrice.create(ticker: tick, date: d.first, price: d.second["5. adjusted close"].to_f )
      end
      earliest_date = StockPrice.where(ticker: tick).minimum(:date)
      Stock.where(ticker: tick).each do |s|
        if s.buytime < earliest_date
          s.update(buytime: earliest_date)
        end
      end
    end
  end
end
