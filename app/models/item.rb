class Item < ApplicationRecord
  monetize :cost_cents
  after_commit :make_stripe_item!

  private 
  # convert a newly entered item to a stripe item and publish it
  def make_stripe_item!
    return unless stripe_product_id.empty?

    temp = Stripe::Product.create({
      name: name,
      description: description,
      default_price_data: {
        unit_amount: cost.cents,
        currency: cost.currency.downcase
      }
    })

    update!(
      stripe_product_id: temp.stripe_product_id,
      stripe_price_id: temp.default_price
    )

  rescue Stripe::StripeError => e 
    errors.add(:base, "#{e.message}")
    false
  end
end
