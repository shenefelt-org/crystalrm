class AddActiveStatusToCustomers < ActiveRecord::Migration[8.1]
  def change
    add_column :customers, :active_customer, :boolean
  end
end
