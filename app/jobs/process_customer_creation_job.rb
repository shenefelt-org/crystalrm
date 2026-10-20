class ProcessCustomerCreationJob < ApplicationJob
  queue_as :default

  # prevent more than 1 worker from processing this job
  limits_concurrency to: 1, key: ->(customer) { customer }

  # retry in this is a network error on this end point
  retry_on Stripe::APIConnectionError, Stripe::RateLimitError, wait: :exponentially_longer, attempts: 3

  def perform(customer:)
    return if customer.stripe_customer_id.present?

    temp = StripeService.create_stripe_customer(customer: customer)
    
  end
end
