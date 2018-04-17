class StockController < ApplicationController
    before_action :authenticate_user!
    before_action :find_stock, only: [:edit,:update,:destroy]
    before_action :correct_user, only: [:edit,:update,:destroy]
    require 'net/http'
    require 'json'
    
    def new
        @stock = Stock.new
    end
    
    def create
        #Check that stock is real & form passes, if not, prevent from creation
        if !StockPrice.find_by(ticker: stock_params[:ticker])
            uri = URI("https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=#{stock_params[:ticker]}&outputsize=compact&apikey=6E5BNXSBW9QWCJHY")
            res = Net::HTTP.get(uri)
            data = JSON.parse(res)
            
            if data["Time Series (Daily)"].nil?
                flash[:danger] = "Not a real ticker"
                redirect_to add_stock_url
                return
            end
            Resque.enqueue(CreateNewStockPriceJob,stock_params[:ticker])
        end
        
        buy_time = Time.new(stock_params["buytime(1i)"].to_i, stock_params["buytime(2i)"].to_i, stock_params["buytime(3i)"].to_i)
        
        if (buy_time > Date.today)
            #Date before today
            buy_time = Date.today
        elsif buy_time < Date.parse('2000-1-1')
            buy_time = Date.parse('2000-1-1')
        end
        
        
        #ERROR IF INCORRECT DATA SENT ADD EXCEPTION HANDLING
        if(stock_params["selltime(1i)"] =~ /\A\d+\z/ ? true : false) or (stock_params["selltime(2i)"] =~ /\A\d+\z/ ? true : false) or (stock_params["selltime(3i)"] =~ /\A\d+\z/ ? true : false)
            sell_time = Time.new(stock_params["selltime(1i)"].to_i, stock_params["selltime(2i)"].to_i, stock_params["selltime(3i)"].to_i)
            
            if(sell_time > Date.today)
                sell_time = Date.today
            elsif sell_time < Date.parse('2000-1-1')
                sell_time = Date.parse('2000-1-1')
            end
            
            if(sell_time <= buy_time)
                flash[:danger] = "Please set your sell time after your buy time"
                redirect_to add_stock_url
                return
            end
            
        else
            sell_time = nil
        end
        
        
        if (stock_params[:quantity].blank?)
            flash[:warning] = "Please enter the quantity"
            redirect_to add_stock_url
            return
        elsif (stock_params[:quantity].to_f <= 0)
            flash[:warning] = "Please enter a positive quantity"
            redirect_to add_stock_url
            return
        end
        
            
        
        if !Stock.create(user_id: current_user.id, ticker: stock_params[:ticker], quantity: stock_params[:quantity], buytime: buy_time, selltime: sell_time)
            flash[:danger] = "Something failed with the create"
            redirect_to add_stock_url
            return
        end
        #Check if any of stock is null
        flash[:success] = "Stock successfully created"
        redirect_to root_url
    end
    
    
    
    
    def edit
        
    end
    
    
    
    def update
        
        #Check that stock is real & form passes, if not, prevent from creation
        if !StockPrice.find_by(ticker: stock_params[:ticker])
            uri = URI("https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=#{stock_params[:ticker]}&outputsize=compact&apikey=6E5BNXSBW9QWCJHY")
            res = Net::HTTP.get(uri)
            data = JSON.parse(res)
            
            if data["Time Series (Daily)"].nil?
                flash[:danger] = "Not a real ticker"
                redirect_to edit_stock_url
                return
            end
            Resque.enqueue(CreateNewStockPriceJob,stock_params[:ticker])
        end
        
        
        
        buy_time = Time.new(stock_params["buytime(1i)"].to_i, stock_params["buytime(2i)"].to_i, stock_params["buytime(3i)"].to_i)
        
        if (buy_time > Date.today)
            #Date before today
            buy_time = Date.today
        elsif buy_time < Date.parse('2000-1-1')
            buy_time = Date.parse('2000-1-1')
        end
        
        
        
        #ERROR IF INCORRECT DATA SENT ADD EXCEPTION HANDLING
        if(stock_params["selltime(1i)"] =~ /\A\d+\z/ ? true : false) or (stock_params["selltime(2i)"] =~ /\A\d+\z/ ? true : false) or (stock_params["selltime(3i)"] =~ /\A\d+\z/ ? true : false)
            sell_time = Time.new(stock_params["selltime(1i)"].to_i, stock_params["selltime(2i)"].to_i, stock_params["selltime(3i)"].to_i)
            
            if(sell_time > Date.today)
                sell_time = Date.today
            elsif sell_time < Date.parse('2000-1-1')
                sell_time = Date.parse('2000-1-1')
            end
            
            if(sell_time <= buy_time)
                flash[:danger] = "Please set your sell time after your buy time"
                redirect_to edit_stock_url
                return
            end
            
        else
            sell_time = nil
        end
        
        
        if (stock_params[:quantity].blank?)
            flash[:warning] = "Please enter the quantity"
            redirect_to add_stock_url
            return
        elsif (stock_params[:quantity].to_f <= 0)
            flash[:warning] = "Please enter a positive quantity"
            redirect_to edit_stock_url
            return
        end
        
            
        
        if !@stock.update(stock_params)
            flash[:danger] = "Something failed with the edit"
            redirect_to edit_stock_url
            return
        end
        flash[:success] = "Stock successfully updated"
        redirect_to root_url
    end
    
    def destroy
        @stock.destroy
        flash[:success] = "Stock Destroyed"
        redirect_to root_url
    end
    
    
    
    private
    
    
    
    def find_stock
        @stock = Stock.find(params[:id])
    end
    
    
    
    def correct_user
        if @stock.user_id != current_user.id
            redirect_to root_url
            flash[:danger] = "You do not have access to edit that stock"
            return
        end
    end
    
    
    
    def stock_params
        params.require(:stock).permit(:ticker,:quantity,:buytime,:selltime)
    end
end
