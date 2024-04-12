class CreateStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :stocks do |t|
      t.string :ts_code       # ts_code str Y TS代码
      t.string :symbol       # symbol  str Y 股票代码
      t.string :name       # name  str Y 股票名称
      t.string :area       # area  str Y 地域
      t.string :industry       # industry  str Y 所属行业
      t.string :fullname       # fullname  str N 股票全称
      t.string :enname       # enname  str N 英文全称
      t.string :cnspell       # cnspell str Y 拼音缩写
      t.string :market       # market  str Y 市场类型（主板/创业板/科创板/CDR）
      t.string :exchange       # exchange  str N 交易所代码
      t.string :curr_type       # curr_type str N 交易货币
      t.string :list_status       # list_status str N 上市状态 L上市 D退市 P暂停上市
      t.string :list_date       # list_date str Y 上市日期
      t.string :delist_date       # delist_date str N 退市日期
      t.string :is_hs       # is_hs str N 是否沪深港通标的，N否 H沪股通 S深股通
      t.string :act_name       # act_name  str Y 实控人名称
      t.string :act_ent_type       # act_ent_type  str Y 实控人企业性质
      t.timestamps
    end
  end
end
