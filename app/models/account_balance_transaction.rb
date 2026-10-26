class AccountBalanceTransaction < ApplicationRecord
  belongs_to :customer
  monetize :amount_cents

  after_create_commit :create_stripe_balance_transaction 

  def to_stripe_hash
    {
      amount: amount_cents,
      currency: amount_currency,
      description: description,
    }

  end

  private
  
  # sig webhook update in queue 
  def create_stripe_balance_transaction 
    return unless customer.present?
    UpdateStripeCustomerBalanceJob.perform_later(transaction: self)
  end



end
