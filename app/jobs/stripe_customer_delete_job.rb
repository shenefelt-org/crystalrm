class StripeCustomerDeleteJob < ApplicationJob
  queue_as :default

  def perform(customer:)
    StripeCustomerService.destroy_customer(customer: customer)
  end
end
