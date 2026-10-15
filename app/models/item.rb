class Item < ApplicationRecord
  has_many :line_items
  has_many :orders, through: :line_items 
  monetize :price_cents

  # Run only on record creation rather than on every update
  after_create_commit :make_stripe_item!

  private

  def make_stripe_item!
    return if stripe_product_id.present?

    temp = Stripe::Product.create({
      name: name,
      description: description,
      default_price_data: {
        unit_amount: price.cents,
        currency: price.currency.to_s.downcase
      }
    })

    update_columns(
      stripe_product_id: temp.id,
      stripe_price_id: temp.default_price
    )

  rescue Stripe::StripeError => e
    log_stripe_error(e, action: "create item")
    false
  end
end
