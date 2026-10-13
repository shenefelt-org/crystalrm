class Project < ApplicationRecord
  belongs_to :customer
  belongs_to :user

  monetize :project_value_cents, with_model_currency: :project_value_currency
  
end
