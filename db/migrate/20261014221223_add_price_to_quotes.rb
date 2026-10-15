class AddPriceToQuotes < ActiveRecord::Migration[8.1]
  def change
    add_monetize :quotes, :price 
  end
end
