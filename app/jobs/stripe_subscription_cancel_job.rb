class StripeSubscriptionCancelJob < ApplicationJob
  queue_as :default

  def perform(sub:)
    # Do something later
    return false unless sub.present?
    StripeSubscriptionService.cancel_stripe_subscription(sub: sub)
  end
end
