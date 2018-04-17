class ProfileController < ApplicationController
    before_action :authenticate_user!
    require 'net/http'
    require 'json'
    
    def home
        @user = current_user
        @stocks = Stock.where(user_id: @user.id)
        @stockData = Hash.new
        
        @stocks.each do |s|
            data = []
            if s.selltime.nil?
                stock_price = StockPrice.where("ticker = ? AND date > ?", s.ticker, s.buytime)
            else
                stock_price = StockPrice.where("ticker = ? AND date > ? AND date < ?", s.ticker, s.buytime, s.selltime)
            end
            
            stock_price.each do |sp|
                day = Hash.new
                day['x'] = sp.date.to_s
                day['y'] = (sp.price * s.quantity).round(1)
                data.push(day)
            end
            @stockData[s.id] = data
        end
        @updating = Hash.new
            
    end
    
    def portfolio
        @user = current_user
        @stocks = Stock.where(user_id: @user.id)
    end
    
end
