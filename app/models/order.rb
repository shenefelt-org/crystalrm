class Order < ApplicationRecord
  belongs_to :project
  belongs_to :customer
  has_many :line_items, dependent: :destroy
  has_many :items, through: :line_items

  monetize :amount_cents, with_model_currency: :ammount_currency

  
end
