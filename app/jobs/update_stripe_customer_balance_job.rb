class UpdateStripeCustomerBalanceJob < ApplicationJob
  queue_as :default

  def perform(customer:)
    StripeCustomerService.update_customer_balance(customer: customer)
  end
end
