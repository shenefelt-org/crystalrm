class AddPastDueToCustomers < ActiveRecord::Migration[8.1]
  def change
    add_column :customers, :past_due, :boolean, default: false
  end
end
