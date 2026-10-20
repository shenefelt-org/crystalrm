class AddStripeQuoteIdToQuotes < ActiveRecord::Migration[8.1]
  def change
    add_column :quotes, :stripe_quote_id, :string
  end
end
