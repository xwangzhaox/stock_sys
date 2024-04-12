# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 获取所有股票数据
response = Sync::Stock.get_stock_list("ts_code,symbol,name,area,industry,market,list_date")
stock_arr = response["items"]
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

# 填充所有股票3年内数据
# 返回字段：["ts_code", "trade_date", "open", "high", "low", "close", "pre_close", "change", "pct_chg", "vol", "amount"]
stocks = Stock.all
stocks.each do |stock|
	stock_data_for_three_years = Sync::Stock.get_stock_by_ts_code(stock.ts_code)
	keys = stock_data_for_three_years["fields"]
	stock_data_for_three_years["items"].each do |record|
		price = Price.find_or_initialize_by(ts_code: record[0], trade_date: record[1])
		if price.new_record?
			price.ts_code = record[0]
			price.trade_date = record[1]
			price.p_open = record[2]
			price.p_high = record[2]
			price.p_low = record[2]
			price.p_close = record[2]
			price.p_pre_close = record[2]
			price.change = record[2]
			price.pct_chg = record[2]
			price.vol = record[2]
			price.amount = record[2]
			price.save
		end
	end
end