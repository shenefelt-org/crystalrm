class AddStripeCustomerIdToCustomers < ActiveRecord::Migration[8.1]
  def change
    add_column :customers, :stripe_customer_id, :string
  end
end
