class AddTokenToUserTable < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :token, :text
  end
end
