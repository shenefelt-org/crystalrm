class AddIsCreditToTransactions < ActiveRecord::Migration[8.1]
  def change
    add_column :account_balance_transactions, :credit, :boolean
  end
end
