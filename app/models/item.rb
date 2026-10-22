class Item < ApplicationRecord
  has_many :line_items
  has_many :quotes, through: :line_items
  monetize :price_cents, with_model_currency: :price_currency

  # Run only on record creation rather than on every update
  after_create_commit :make_stripe_item!
  after_update :sync_stripe_item_update!, if: :stripe_fields_changed?

  private

  # to pass self here you must not use a keyword arg or the whole obj is serialzed
  def make_stripe_item!
    StripeItemCreationJob.perform_later(item: self)
  end

  def sync_stripe_item_update
    StripeItemUpdateJob.perform_later(
      item: self,
      price_changed: saved_change_to_price_cents?
    )
  end

  def stripe_fields_changed?
    stripe_product_id.present? && (
      saved_change_to_name? || saved_change_to_description? || saved_change_to_active? || saved_change_to_price_cents?
    )
  end
end
