class SyncStockDaliyData
  include Sidekiq::Worker

  def perform
    @stocks = Stock.all
    stock_daliy_data = Sync::Stock.get_stock_by_ts_code(
      "002092.SZ",
      start_date: (Time.now-1.days).strftime("%Y%m%d"),
      end_date: Time.now.strftime("%Y%m%d")
    )
  end
end
