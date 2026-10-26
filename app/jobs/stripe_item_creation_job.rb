class StripeItemCreationJob < ApplicationJob
  queue_as :default

  def perform(item:)
    # return nil unless item.present?
    StripeItemService.create_item(item: item)
  end
end
