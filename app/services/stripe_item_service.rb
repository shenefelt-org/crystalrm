class StripeItemService
  @pastel = Pastel.new
  # create a new item inside the stripe catalog
  def self.create_item(item:)
    # return unless item.present? && item.stripe_product_id.nil?

    temp_item = Stripe::Product.create(
      {
        name: item.name,
        description: item.description,
        statement_descriptor: "#{item.id} sale",
        metadata: {
          local_item_id: item.id
        }
      }
    )

    temp_price = Stripe::Price.create(
      {
        product: temp_item.id,
        unit_amount: item.price_cents,
        currency: item.price_currency.to_s.downcase,
        recurring: {
          interval: item.recurring_interval
        },
        metadata: {
          is_subscription: item.recurring_interval == "month"
        }

      }
    )

    item.update!(
      stripe_product_id: temp_item.id,
      stripe_price_id: temp_price.id
    )
  rescue Stripe::StripeError => e
  end

  # handle updates to an item in the catalog - price changes require new Price creation.
  def self.update_item(item:, price_changed: false)
    # handle non price change updates
    Stripe::Product.update(
      item.stripe_product_id,
      {
        name: item.name,
        description: item.description,
        active: item.active?
      }
    )

    # handle price change event as updates to price require a new stripe price obj
    if price_changed
      # be rid of the old price by archive
      Stripe::Price.update(item.stripe_price_id, { active: false }) if item.stripe_price_id.present?

      # gen new price id
      temp = Stripe::Price.create({
        product: item.stripe_product_id,
        unit_amount: item.price_cents.to_i,
        currency: item.price_currency
      })

      # update product price
      Stripe::Product.update(item.stripe_product_id, { default_price: temp.id })
      item.update!(stripe_price_id: temp.id)
    end

  rescue Stripe::StripeError => e
    colorize_errors(err: e)
  end


  private 

  def self.colorize_errors(err:)
    return unless err.present?
    puts @pastel.red.on_white(err.message)
  end
end