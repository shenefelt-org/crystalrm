class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.string :status, default: "draft", null: false 
      t.string :stripe_checkout_session_id
      t.references :customer, null: false, foreign_key: true
      # represent the user as a manager for the project
      t.references :user, null: false, foreign_key: true
      t.monetize :project_value, currency: { default: 'USD' }
      t.timestamps
    end
  end
end
