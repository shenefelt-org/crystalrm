class CreateLineItems < ActiveRecord::Migration[8.1]
  def change
    create_table :line_items do |t|
      drop_table :line_items, if_exists: true
      t.references :quote, foreign_key: true, null: true
      t.references :item, foreign_key: true, null: true
      t.integer :quantity, default: 1, null: true
      t.monetize :unit_price
      t.timestamps
    end
  end
end
