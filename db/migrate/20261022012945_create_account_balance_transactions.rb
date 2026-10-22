class CreateAccountBalanceTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :account_balance_transactions do |t|
      t.references :customer, null: false, foreign_key: true

      t.monetize :amount, 
                 null: false, 
                 default: 0, 
                 currency: { present: true, default: "usd" }

      t.string :stripe_balance_transaction_id
      t.string :description
      t.integer :transaction_type, default: 0, null: false

      t.timestamps
    end

    add_index :account_balance_transactions, :stripe_balance_transaction_id, unique: true
  end
end