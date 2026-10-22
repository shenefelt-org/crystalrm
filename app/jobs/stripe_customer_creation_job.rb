class StripeCustomerCreationJob < ApplicationJob
  queue_as :default

  def perform(customer:)
    return nil if customer.nil? || customer.stripe_customer_id.present?
    temp = StripeService.create_stripe_customer(customer)

    customer.update!(stripe_customer_id: temp.id)

  end
end
