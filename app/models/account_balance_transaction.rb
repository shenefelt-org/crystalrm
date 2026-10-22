class AccountBalanceTransaction < ApplicationRecord
  belongs_to :customer
  monetize :amount_cents

  
end
