class StripeItemUpdateJob < ApplicationJob
  queue_as :default

  def perform(item:, price_changed: false)
    return unless item.present?
    StripeItemService.update_item(item: item, price_changed: price_changed)
  end
end
