class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.string :stripe_product_id
      t.string :stripe_price_id
      t.boolean :active, default: true, null: false
      t.string :recurring_interval # one time purchase or subscription

      t.monetize :price, currency: { default: 'USD' }


      t.timestamps
    end

    add_index :items, :stripe_product_id, unique: true
    add_index :items, :stripe_price_id, unique: true
  end
end
