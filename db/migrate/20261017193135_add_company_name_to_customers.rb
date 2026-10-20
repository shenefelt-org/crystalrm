class AddCompanyNameToCustomers < ActiveRecord::Migration[8.1]
  def change
    add_column :customers, :company_name, :string
  end
end
