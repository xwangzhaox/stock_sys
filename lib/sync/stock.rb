# 获取股票数据api对接
# https://tushare.pro/
# 接口文档：https://tushare.pro/document/2?doc_id=27

module Sync
	class Stock

		# 获取所有股票数据
		# https://tushare.pro/document/2?doc_id=25
		# Sync::Stock.get_stock_list
		# e.g. {"request_id"=>"5b3b3a6af02a11eea2e16360f77606dd", "code"=>0, "msg"=>"", "data"=>{"fields"=>["ts_code", "name", "area", "industry", "list_date"], "items"=>[["000001.SZ", "平安银行", "深圳", "银行", "19910403"]], "has_more"=>false}}
		# 可用fields：
		# ts_code	str	Y	TS代码
		# symbol	str	Y	股票代码
		# name	str	Y	股票名称
		# area	str	Y	地域
		# industry	str	Y	所属行业
		# fullname	str	N	股票全称
		# enname	str	N	英文全称
		# cnspell	str	Y	拼音缩写
		# market	str	Y	市场类型（主板/创业板/科创板/CDR）
		# exchange	str	N	交易所代码
		# curr_type	str	N	交易货币
		# list_status	str	N	上市状态 L上市 D退市 P暂停上市
		# list_date	str	Y	上市日期
		# delist_date	str	N	退市日期
		# is_hs	str	N	是否沪深港通标的，N否 H沪股通 S深股通
		# act_name	str	Y	实控人名称
		# act_ent_type	str	Y	实控人企业性质
		def self.get_stock_list(fields = "ts_code,symbol,name,area,industry,market,list_date")
			send_request(
				'stock_basic', 
				{list_stauts: "L", market: "主板"},
				fields: fields
			)
		end

		# 获取单只股票3年的数据
		# Sync::Stock.get_stock_by_ts_code("002092.SZ",start_date: (Time.now-1.days).strftime("%Y%m%d"),end_date: Time.now.strftime("%Y%m%d"))
		# e.g. {"fields"=>["ts_code", "trade_date", "open", "high", "low", "close", "pre_close", "change", "pct_chg", "vol", "amount"], "items"=>[["002092.SZ", "20240401", 4.58, 4.81, 4.58, 4.79, 4.57, 0.22, 4.814, 355371.25, 168364.674], ["002093.SZ", "20240401", 7.1, 7.21, 7.06, 7.17, 7.09, 0.08, 1.1283, 101063.0, 72199.355]], "has_more"=>false}
		# 返回字段：
		# ts_code	str	股票代码
		# trade_date	str	交易日期
		# open	float	开盘价
		# high	float	最高价
		# low	float	最低价
		# close	float	收盘价
		# pre_close	float	昨收价(前复权)
		# change	float	涨跌额
		# pct_chg	float	涨跌幅 （未复权，如果是复权请用 通用行情接口 ）
		# vol	float	成交量 （手）
		# amount	float	成交额 （千元）
		def self.get_stock_by_ts_code(ts_code, start_date: (Time.now-3.years).strftime("%Y%m%d"), end_date: Time.now.strftime("%Y%m%d"))
			send_request('daily', {
					ts_code: ts_code,
					start_date: start_date,
					end_date: end_date
			})
		end

		private
		# 接口请求封装函数，完整接口返回如下，如果code为0则为请求正常，则直接返回response中的Data部分
		# {"request_id"=>"5b3b3a6af02a11eea2e16360f77606dd", "code"=>0, "msg"=>"", "data"=>{"fields"=>["ts_code", "name", "area", "industry", "list_date"], "items"=>[["000001.SZ", "平安银行", "深圳", "银行", "19910403"]], "has_more"=>false}}
		def self.send_request(interface, params, fields: false)
			data = {
				api_name: interface,
				token: Rails.application.credentials.tushare_token, 
				params: params
			}
			fields && data.merge!({fields: fields})
			url = 'http://api.tushare.pro'
			response = HttpRequest.curl_post_request_with_params(url, data.to_json)
			response["code"] == 0 ? response["data"] : false
		end
	end	
end