class Quote < ApplicationRecord
  belongs_to :customer
  has_many :line_items, dependent: :destroy
  has_many :items, through: :line_items

  monetize :price_cents
  after_create_commit :create_stripe_quote!

  def total
    line_items.sum(&:total)
  end

  private

  # Create the non-finalized quote in Stripe
  def create_stripe_quote!
    temp = Stripe::Quote.create({
      customer: quote.customer.stripe_customer_id,
      line_items: map_line_items,
      description: "#{quote.customer.full_name} quote",
      expires_at: 30.days.from_now.to_i,
      header: "Shenefelt ORG"
    })
    # Store non final quote number on model
    update!(quote_number: temp.id)

  rescue Stripe::StripeError => e
    log_stripe_error(e, action: "create quote")
    false
  end

  # helper - returns stripe required format of [{},{}] i.e array of hashes
  def map_line_items
    return if line_items.count.zero?
    line_items.map! do |item|
      {
        price: item.stripe_price_id,
        price_data: {
          currency: item.unit_price_currency.downcase
        },
        quantity: item.quantity
      }
    end
  end
end
