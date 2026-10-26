class StripeSubscriptionCreateJob < ApplicationJob
  queue_as :default

  def perform(sub:)
    return false unless sub.present?
    StripeSubscriptionService.create_subscription(customer: sub.customer, item: sub.item)
  end
end
