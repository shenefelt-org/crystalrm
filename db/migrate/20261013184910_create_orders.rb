class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :project, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.string :order_number, null: true
      t.string :status, default: "pending", null:false 

      t.monetize :amount, currency: { default: 'USD' }

      t.string :description
      t.string :access_token
      t.string :stripe_checkout_session_id
      t.string :stripe_payment_intent_id
      t.datetime :paid_at

      t.timestamps
    end
    add_index :orders, :access_token, unique: true
    add_index :orders, :stripe_checkout_session_id
    add_index :orders, :order_number, unique: true 
  end
end
