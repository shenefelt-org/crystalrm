class Subscription < ApplicationRecord
  belongs_to :customer
  belongs_to :item

  monetize :price_cents

  # after_create_commit :create_stripe_subscription!
  # after_update :cancel_stripe_subscription!, if: :params_changed?

  def active?
    status == "active"
  end

  private

  def create_stripe_subscription!
    StripeSubscriptionCreateJob.perform_later(sub: self)
  end

  def cancel_stripe_subscription!
    return unless stripe_subscription_id.present?
    StripeSubscriptionCancelJob.perform_later(sub: self)
  end

  private 

  def params_changed?
    stripe_subscription_id.present? && saved_change_to_customer_id? || saved_change_to_status? || saved_changed_price_cents? || saved_change_to_item?
  end
end
