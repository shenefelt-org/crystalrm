class CreateSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :subscriptions do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :plan, null: false, foreign_key: true
      t.string :stripe_subscription_id
      t.string :status
      t.monetize :price, null: false, currency: { null: false, default: 'usd'}
      t.datetime :current_period_end

      t.timestamps
    end

    add_index :subscriptions, :stripe_subscription_id, unique: true
  end
end
