class AddAccountBalanceToCustomers < ActiveRecord::Migration[8.1]
  def change
    add_monetize :customers, :balance, 
                 amount: { null: false, default: 0 }, 
                 currency: { null: false, default: 'USD' }
  end
end
