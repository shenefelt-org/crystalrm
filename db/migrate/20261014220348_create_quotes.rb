class CreateQuotes < ActiveRecord::Migration[8.1]
  def change
    create_table :quotes do |t|
      t.string :quote_number
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end

    add_index :quotes, :quote_number, unique: true
  end
end
