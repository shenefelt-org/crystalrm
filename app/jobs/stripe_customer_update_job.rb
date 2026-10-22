class StripeCustomerUpdateJob < ApplicationJob
  queue_as :default

  def perform(customer:)
    # Do something later
    StripeCustomerService.update_customer(customer: customer)
  end
end
