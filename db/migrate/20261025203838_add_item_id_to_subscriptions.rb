class AddItemIdToSubscriptions < ActiveRecord::Migration[8.1]
  def change
    add_reference :subscriptions, :item, null: false, foreign_key: true
  end
end
