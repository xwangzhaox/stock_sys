class SyncStockListData
  include Sidekiq::Worker

  def perform
    response = Sync::Stock.get_stock_list("ts_code,symbol,name,area,industry,market,list_date")
    stock_arr = response.items
    stock_arr.each do |stock|
      stock = Stock.find_or_initialize_by(ts_code: stock[0])
      if stock.new_record?
        stock.symbol = stock[1]
        stock.name = stock[2]
        stock.area = stock[3]
        stock.industry = stock[4]
        stock.market = stock[4]
        stock.list_date = stock[4]
        stock.save
      end
    end
  end
end