class AddDescriptionToCustomers < ActiveRecord::Migration[8.1]
  def change
    add_column :customers, :description, :string
  end
end
