class RemoveJunkFromProjects < ActiveRecord::Migration[8.1]
  def change
    remove_column :projects, :stripe_checkout_session_id, :string
    remove_column :projects, :project_value_cents, :string
    remove_column :projects, :project_value_currency, :string
  end
end
